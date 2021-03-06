module Carrot::AMQP
  class Queue
    attr_reader   :name, :carrot
    attr_accessor :delivery_tag

    def initialize(carrot, name, opts = {})
      @opts   = opts
      @name   = name
      @carrot = carrot
      server.send_frame(
              Protocol::Queue::Declare.new({ :queue => name, :nowait => true }.merge(opts))
      )
    end

    def pop(opts = {})
      self.delivery_tag = nil
      server.send_frame(
              Protocol::Basic::Get.new({ :queue => name, :consumer_tag => name, :no_ack => !opts.delete(:ack), :nowait => true }.merge(opts))
      )
      method = server.next_method
      return unless method.kind_of?(Protocol::Basic::GetOk)

      self.delivery_tag = method.delivery_tag

      header = server.next_payload

      msg = ''
      while msg.length < header.size
        msg << server.next_payload
      end

      msg
    end

    def ack
      server.send_frame(
              Protocol::Basic::Ack.new(:delivery_tag => delivery_tag)
      )
    end

    def publish(data, opts = {})
      exchange.publish(data, opts)
    end

    def message_count
      status.first
    end

    def consumer_count
      status.last
    end

    def status(opts = {}, &blk)
      server.send_frame(
              Protocol::Queue::Declare.new({ :queue => name, :passive => true }.merge(opts))
      )
      method = server.next_method
      return [nil, nil] if method.kind_of?(Protocol::Connection::Close)

      [method.message_count, method.consumer_count]
    end

    def bind(exchange, opts = {})
      exchange           = exchange.respond_to?(:name) ? exchange.name : exchange
      bindings[exchange] = opts
      server.send_frame(
              Protocol::Queue::Bind.new({ :queue => name, :exchange => exchange, :routing_key => opts.delete(:key), :nowait => true }.merge(opts))
      )
    end

    def unbind(exchange, opts = {})
      exchange = exchange.respond_to?(:name) ? exchange.name : exchange
      bindings.delete(exchange)

      server.send_frame(
              Protocol::Queue::Unbind.new({
                      :queue => name, :exchange => exchange, :routing_key => opts.delete(:key), :nowait => true }.merge(opts)
              )
      )
    end

    def delete(opts = {})
      server.send_frame(
              Protocol::Queue::Delete.new({ :queue => name, :nowait => true }.merge(opts))
      )
      carrot.queues.delete(name)
    end

    def purge(opts = {})
      server.send_frame(
              Protocol::Queue::Purge.new({ :queue => name, :nowait => true }.merge(opts))
      )
    end

    def server
      carrot.server
    end

    ##
    # Is a wrapper around publish to send persistent messages.

    def send_message(data,opts={})
      opts.merge!(:persistent => true)
      # Encrypt the message using the password supplied
      data = encrypt_message(data, opts[:password]) if opts[:password]
      exchange.publish(data,opts)
    end


    ##
    # This message will decrypt the message if a password is passed.
    # Else it will pop the message as it is.

    def receive_message(opts={})
      msg      = pop(opts)
      password = opts[:password]
      if msg && password
        decrypted_message = decrypt_message(msg, password)
        decrypted_message
      end
      decrypted_message || msg
    end

    def encrypt_message(message, password)
      encrypted_message = message.encrypt(:symmetric, :password => password)
      encrypted_message
    end

    def decrypt_message(message, password)
      decrypted_message = message.decrypt(:symmetric, :password => password)
      decrypted_message
    end

    ##
    # Is a wrapper around publish to send persistent and encrypted messages using symmetric key.

    def encrypt_and_send_message(opts={})
      opts.merge!(:persistent => true)
      encrypted_message = encrypt_message(opts[:message], opts[:password])
      exchange.publish(encrypted_message,opts)
    end

    ##
    # This method will receive and decrypt messages using symmetric key.

    def receive_and_decrypt_message(opts={})
      msg  = pop(opts)
      unless msg.nil?
        decrypted_message = decrypt_message(msg, opts[:password])
        decrypted_message
      end
      decrypted_message || msg
    end

    private
    def exchange
      @exchange ||= Exchange.new(carrot, :direct, '', :key => name)
    end

    def bindings
      @bindings ||= {}
    end
  end
end

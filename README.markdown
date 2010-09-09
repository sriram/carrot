# Carrot

A synchronous amqp client. Based on Aman's amqp client:

[http://github.com/tmm1/amqp/tree/master] (http://github.com/tmm1/amqp/tree/master)

## Motivation

This client does not use eventmachine so no background thread necessary. As a result, it is much easier to use from script/console and Passenger. It also solves the problem of buffering messages and ack responses. For more details see [this thread] (http://groups.google.com/group/ruby-amqp/browse_thread/thread/fdae324a0ebb1961/fa185fdce1841b68).

There is currently no way to prevent buffering using eventmachine. Support for prefetch is still unreliable.


## Example
    
    require 'secure_carrot'

    q = Carrot.queue('name')
    10.times do |num|
      q.publish(num.to_s)
    end
    
    puts "Queued #{q.message_count} messages"
    puts
    
    while msg = q.pop(:ack => true)
      puts "Popping: #{msg}"
      q.ack
    end
    Carrot.stop

## Encrypting and Decrypting messages

Symmetric encryption is used here which means the same password is used for encrypting
and decrypting the message.

    puts "Encrypt and send a message"
    q.send_message('Hello Carrot', :password => 'secure')
    #=> "qrbSyJHx6JhBQtXKsWvm/A==\n"

    puts "Receiving and decrypting message. If you don't specify the password you will read an encrypted message."
    q.receive_message(:password => 'secure')
    #=> "Hello Carrot"
    
# LICENSE

Copyright (c) 2009 Amos Elliston, Geni.com; Published under The MIT License, see License

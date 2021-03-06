# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{secure_carrot}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sriram Varahan"]
  s.date = %q{2010-09-09}
  s.description = %q{A fork of carrot with added features for encrypting and decrypting messages.}
  s.email = %q{sriram.varahan@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION.yml",
     "lib/amqp/buffer.rb",
     "lib/amqp/exchange.rb",
     "lib/amqp/frame.rb",
     "lib/amqp/header.rb",
     "lib/amqp/protocol.rb",
     "lib/amqp/queue.rb",
     "lib/amqp/server.rb",
     "lib/amqp/spec.rb",
     "lib/examples/simple_pop.rb",
     "lib/secure_carrot.rb",
     "test/carrot_test.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/sriram/carrot}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A synchronous version of the ruby amqp client with added security features}
  s.test_files = [
    "test/carrot_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<encrypted_strings>, [">= 0"])
    else
      s.add_dependency(%q<encrypted_strings>, [">= 0"])
    end
  else
    s.add_dependency(%q<encrypted_strings>, [">= 0"])
  end
end


# https://www.ruby-forum.com/topic/82218

# http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/138320

# Hacks to integrate rspec's expect 
# Even more ... complicate setup is available here:

# http://avdi.org/talks/rockymtnruby-2011/things-you-didnt-know-about-exceptions.html
require 'rspec/expectations'
require 'continuation'

class Exception
  attr_accessor :continuation
  def ignore
    continuation.call
  end
end

module RaiseWithIgnore
  def raise(*args)
    callcc do |continuation|
      begin
        super
      rescue Exception => e
        e.continuation = continuation
        super(e)
      end
    end
  end  
end

# Yep. Augmented all of RSpec Error objects with ability to "keep going".
class Object
  include RaiseWithIgnore
end

module ErrorCollector
  module Matchers
    class PassAllExpects

      def initialize(block_description)
        @block_desc = block_description || "current test"
        @exceptions = []
      end

      def matches?(block_to_test)
        begin
          block_to_test.call
        rescue RSpec::Expectations::ExpectationNotMetError => e
          bck = e.backtrace
          bck.shift
          collected = e.exception(e.message)
          collected.set_backtrace bck.slice(5,2)
          @exceptions << collected

          e.ignore # Magic and Unicorn happens here.
        end
        @exceptions.empty?
      end

      def does_not_matches?(block_to_test)
        !matches?(block_to_test)
      end

      def failure_message_for_should
        return @exceptions.first if @exceptions.size == 1
        
        @exceptions.map do |e|
          "\n\n" + e.message + "\n\n" + e.backtrace.join("\n") + "\n\n"
        end.join("=" * 80)
      end

      def failure_message_for_should_not
        "Expects test cases to fail but it passed"
      end
    end

    def pass_all_expects(block_description = nil)
      Matchers::PassAllExpects.new(block_description)
    end

  end
end

RSpec.configure do |config|
  config.include ErrorCollector::Matchers
  config.backtrace_exclusion_patterns << /error_collector/ 
end

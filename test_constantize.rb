module One
  module Two
    class Three
      def say_hi
        puts "say hi"
      end
    end
  end
end

one = Object.const_get "One"

puts one.class # => Module

three = One::Two.const_get "Three"

puts three.class # => Class

three.new.say_hi # => "say hi"
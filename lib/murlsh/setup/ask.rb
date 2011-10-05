module Murlsh

  module Setup

    module_function

    # Ask the user a question and return the answer.
    def ask(prompt, default=nil)
      default_given = !default.to_s.empty?
      print "#{prompt} "
      print "[#{default}] "  if default_given
      answer = $stdin.gets.strip
      answer = default  if answer.empty? and default_given
      answer
    end

  end

end

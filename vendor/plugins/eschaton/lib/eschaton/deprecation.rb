module Eschaton

  class Deprecation

    def self.enabled?
      @@enabled ||= true
    end

    def self.enable!
      @@enabled = true
    end

    def self.disable!
      @@enabled = false
    end

    def self.warning(options)
      options = {:message => options} if options.is_a?(String)
      options.default! :include_called_from => true

      if self.enabled?
        message = "Eschaton deprecation warning: #{options[:message]}."
        message+= "Called from #{self.get_caller(caller)}" if options[:include_called_from].true?

        $stderr.puts message
      end
    end
    
    protected
      def self.get_caller(call_stack)
        framework_call_pattarn = /ruby|actionmailer|actionpack|activerecord|activeresource|activesupport|railties/
        applcation_calls = call_stack.reject! do |call|
                             call =~ framework_call_pattarn
                           end

        applcation_calls[1].gsub(RAILS_ROOT, '')
      end
  
  end
 
end
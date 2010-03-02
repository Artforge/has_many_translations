module HasManyTranslations
  
  module Configuration
    def configure
      yield Configuration
    end

    class << self
      # Simply stores a hash of options given to the +configure+ block.
      def options
        @options ||= {}
      end

      # If given a setter method name, will assign the first argument to the +options+ hash with
      # the method name (sans "=") as the key. If given a getter method name, will attempt to
      # a value from the +options+ hash for that key. If the key doesn't exist, defers to +super+.
      def method_missing(symbol, *args)
        if (method = symbol.to_s).sub!(/\=$/, '')
          options[method.to_sym] = args.first
        else
          options.fetch(method.to_sym, super)
        end
      end
    end 
  end
end
module HasManyTranslations
  # Provides +has_translations+ options conversion and cleanup.
  
  module Options
    
    def self.included(base) # :nodoc:
      base.class_eval do
        extend ClassMethods
      end
    end

    # Class methods that provide preparation of options passed to the +has_translations+ method.
    module ClassMethods
      # The +prepare_has_translations_options+ method has three purposes:
      # 1. Populate the provided options with default values where needed
      # 2. Prepare options for use with the +has_many+ association
      # 3. Save user-configurable options in a class-level variable
      #
      # Options are given priority in the following order:
      # 1. Those passed directly to the +translated+ method
      # 2. Those specified in an initializer +configure+ block
      # 3. Default values specified in +prepare_has_translations_options+
      #
      # The method is overridden in feature modules that require specific options outside the
      # standard +has_many+ associations.
      def prepare_translated_options(options)
        options.symbolize_keys!
        options.reverse_merge!(Configuration.options)
        options.reverse_merge!(
          :class_name => 'HasManyTranslations::Translation',
          :dependent => :delete_all
        )
        class_inheritable_accessor :has_many_translations_options
        class_inheritable_accessor :translator
        self.translator = Translate::RTranslate.new
        if defined? HmtSettings
          self.translator.key = HmtSettings.google_api_key
          options[:default_languages] = HmtSettings.default_languages ? HmtSettings.default_languages : nil
          options[:languages] = HmtSettings.languages ? HmtSettings.languages : nil
          options[:force_on_update] = HmtSettings.force_on_update ? HmtSettings.force_on_update : nil
          
        end
        self.has_many_translations_options = options.dup

        options.merge!(
          :as => :translated,
          :extend => Array(options[:extend]).unshift(Translations)
        )
      end
    end
  end
end

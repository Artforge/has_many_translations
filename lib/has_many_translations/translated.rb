module HasManyTranslations
  # Simply adds a flag to determine whether a model class is has_translations.
  module Translated
    def self.extended(base) # :nodoc:
      base.class_eval do
        class << self
          alias_method_chain :translated, :flag
        end
      end
    end
    # Overrides the +has_translations+ method to first define the +has_translations?+ class method before
    # deferring to the original +has_translations+.
    def translated_with_flag(*args)
      #not sure why this was in vestal removing for the moment
      translated_without_flag(*args)  

      class << self
        def translated?
          true
        end
      end
    end

    # For all ActiveRecord::Base models that do not call the +translated?+ method, the +has_translations?+
    # method will return false.
    def translated?
      false
    end
  end
end
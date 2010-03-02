module HasManyTranslations
  # Simply adds a flag to determine whether a model class is has_translations.
  module HasTranslations
    def self.extended(base) # :nodoc:
      base.class_eval do
        class << self
          alias_method_chain :has_translations, :flag
        end
      end
    end
    # Overrides the +has_translations+ method to first define the +has_translations?+ class method before
    # deferring to the original +has_translations+.
    def has_translations_with_flag(*args)
      has_translations_without_flag(*args)

      class << self
        def has_translations?
          true
        end
      end
    end

    # For all ActiveRecord::Base models that do not call the +has_translations+ method, the +has_translations?+
    # method will return false.
    def has_translations?
      false
    end
  end
end
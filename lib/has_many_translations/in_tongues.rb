module HasManyTranslations
  # Simply adds a flag to determine whether a model class is has_translations.
  module InTongues
    def self.extended(base) # :nodoc:
      base.class_eval do
        class << self
          alias_method_chain :in_toungues, :flag
        end
      end
    end
    # Overrides the +has_translations+ method to first define the +has_translations?+ class method before
    # deferring to the original +has_translations+.
    def in_tongues_with_flag(*args)
      in_tongues_without_flag(*args)

      class << self
        def in_tongues?
          true
        end
      end
    end

    # For all ActiveRecord::Base models that do not call the +has_translations+ method, the +has_translations?+
    # method will return false.
    def in_tongues?
      false
    end
  end
end
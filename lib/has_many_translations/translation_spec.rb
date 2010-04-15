module HasManyTranslations
    # The ActiveRecord model representing translations.
    class TranslationSpec < ActiveRecord::Base
      # Associate polymorphically with the parent record.
      belongs_to :translated, :polymorphic => true
    end
end
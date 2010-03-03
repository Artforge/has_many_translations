module HasManyTranslations
  class Translation < ActiveRecord::Base
    # Associate polymorphically with the parent record.
    belongs_to :in_tongues, :polymorphic => true
  end
end
    
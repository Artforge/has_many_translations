class TranslationSpec < ActiveRecord::Base
  belongs_to :translated, :polymorphic => true
end
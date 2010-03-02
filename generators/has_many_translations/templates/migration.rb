class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
      t.belongs_to :translated, :polymorphic => true
      t.string :language
      t.string :attribute
      t.text :translation
      t.timestamps
    end

    change_table :translations do |t|
      t.index [:translated_id, :translated_type]
      t.index :language
      t.index :attribute
      t.index :created_at
    end
  end

  def self.down
    drop_table :translations
  end
end
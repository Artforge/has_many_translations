class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :locales do |t|
      t.string   :code
      t.string   :name
    end
    add_index :locales, :code
    create_table :translations do |t|
      t.belongs_to :translated, :polymorphic => true
      t.string   :attribute
      t.text     :value
      t.integer  :locale_id
      
      t.timestamps
    end
    add_index :translations, [:locale_id, :attribute]
    add_index :translations, [:translated_id, :translated_type]
    
    change_table :users do |t|
      add_column :users, :prefered_language, :string
    end
  end

  def self.down
    drop_table :locales
    drop_table :translations
    #drop_table :asset_translations
    remove_column :users, :prefered_language
  end
end

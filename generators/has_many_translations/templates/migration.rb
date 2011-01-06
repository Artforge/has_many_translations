class CreateTranslations < ActiveRecord::Migration
  def self.up    # 
    create_table :translation_specs do |t|
      t.belongs_to :translated, :polymorphic => true
      t.string   :codes
    end
    add_index :translation_specs, :codes
    add_index :translation_specs, [:translated_id, :translated_type]
    
    create_table :translations do |t|
      t.belongs_to :translated, :polymorphic => true
      t.string   :model_attribute
      t.text     :value
      t.string   :locale_code
      t.string   :locale_name
      t.string   :origin_locale_code
      t.boolean  :machine_translation
      t.timestamps
    end
    add_index :translations, [:locale_code, :model_attribute]
    add_index :translations, [:translated_id, :translated_type]
    
    change_table :users do |t|
      add_column :users, :prefered_language, :string
    end
  end

  def self.down
    drop_table :translation_spec
    drop_table :translations
    remove_column :users, :prefered_language
  end
end

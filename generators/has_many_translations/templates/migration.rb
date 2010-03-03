class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
      t.belongs_to :in_tongues, :polymorphic => true
      t.string :language
      t.string :attribute
      t.text :translation
      t.timestamps
    end

    change_table :translations do |t|
      t.index [:in_tongues_id, :in_tongues_type]
      t.index :language
      t.index :attribute
      t.index :created_at
    end
    
    change_table :users do |t|
      add_column :users, :prefered_language, :string
    end
  end

  def self.down
    drop_table :translations
    remove_column :users, :prefered_language
  end
end

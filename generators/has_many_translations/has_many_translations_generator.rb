class HasManyTranslationsGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'migration.rb', File.join('db', 'migrate'), :migration_file_name => 'create_translations'

      m.directory File.join('config', 'initializers')
      m.template 'initializer.rb', File.join('config', 'initializers', 'has_many_translations.rb')
    end
  end
end

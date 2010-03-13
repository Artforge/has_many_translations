module HasManyTranslations
  # An extension module for the +has_many+ association with translations.
  module Translations
    # Returns all translations for given language. 
    
    def by_lang(lang)
      all(:conditions => "#{aliased_table_name}.locale_id eq '#{locale}'")
    end
  end
  
end
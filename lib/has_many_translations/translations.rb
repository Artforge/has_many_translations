module HasManyTranslations
  # An extension module for the +has_many+ association with translations.
  module Translations
    # Returns all translations for given language. 
    
    def language(attributes = nil, lang)
      
      all(:conditions => "#{aliased_table_name}.language eq '#{lang}'")
    end
  end
  
end
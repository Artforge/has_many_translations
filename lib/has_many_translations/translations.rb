module HasManyTranslations
  # An extension module for the +has_many+ association with translations.
  module Translations
    # Returns all translations for given language. 
    
    def by_lang(lang)
      all(:conditions => "#{aliased_table_name}.locale_code eq '#{locale}'")
    end
    
    # def by_locale(locale)
    #      first(:conditions => { :locale => locale.to_s })
    #    end
    # 
    #    def by_locales(locales)
    #      all(:conditions => { :locale => locales.map(&:to_s) })
    #    end
  end
  
end
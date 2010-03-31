
module TranlationJobs
  class MachineTranslationJob < Struct.new(:translated_id, :translated_type, :origin_locale)
    def perform
      translatable = Kernel.const_get(translated_type).find(translated_id)
      translatable.update_translations!
    end
  end
  class AutoTranslateJob < Struct.new(:translated_id, :translated_type, :origin_locale, :destination_locale)
    def perform
      translatable = Kernel.const_get(translated_type).find(translated_id)
      translatable.update_all_attributes_translation(destination_locale, origin_locale)
    end
  end 
  
  
end
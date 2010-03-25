
module Jobs
  class MachineTranslationJob < Struct.new(:translated_id, :translated_type, :origin_locale)
    def perform
      translatable = Kernel.const_get(translated_type).find(translated_id)
      translatable.update_translations!
    end
  end
  
  
end
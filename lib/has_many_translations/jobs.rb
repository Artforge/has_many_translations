
module Jobs
  class MachineTranslationJob < Struct.new(:translated_id, :translated_type)
    def perform
      translatable = Kernel.const_get(translated_type).find(translated_id)
      translatable.update_translations!
    end
  end
  
  
end

module TranslationJobs
      class MachineTranslationJob
        attr_accessor :translated_id, :translated_type, :origin_locale
        
         def initialize(options)
            self.translated_id = options[:translated_id]
            self.translated_type =  options[:translated_type]
            self.origin_locale =  options[:origin_locale]
          end
           def perform
             translatable = Kernel.const_get(@translated_type).find(@translated_id)
             translatable.update_translations!
            
           end
      end
      class AutoTranslateJob 
        attr_accessor :translated_id, :translated_type, :origin_locale, :destination_locale
        
         def initialize(options)
            self.translated_id = options[:translated_id]
            self.translated_type =  options[:translated_type]
            self.origin_locale =  options[:origin_locale]
            self.destination_locale =  options[:destination_locale]
          end
        def perform
          translatable = Kernel.const_get(@translated_type).find(@translated_id)
          translatable.update_all_attributes_translation(@destination_locale, @origin_locale)
        end
      end 
end
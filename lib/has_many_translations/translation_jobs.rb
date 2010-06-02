
module TranslationJobs
      class MachineTranslationJob
        attr_accessor :translated_id, :translated_type
         def initialize(options)
            @translated_id = options["translated_id"] || options[:translated_id]
            @translated_type =  options["translated_type"] || options[:translated_type]
          end
           def perform
             translatable = Kernel.const_get(@translated_type).find(@translated_id)
             translatable.update_translations!
            
           end
      end
      
      class AutoTranslateJob 
        attr_accessor :translated_id, :translated_type, :origin_locale, :destination_locale
        
        def initialize(options)
          @translated_id = options["translated_id"]||options[:translated_id]
          @translated_type =  options["translated_type"]||options[:translated_type]
          @origin_locale =  options["origin_locale"]||options[:origin_locale]
          @destination_locale = options["destination_locale"]|| options[:destination_locale]
        end
        
        def perform(options = nil)
          translatable = Kernel.const_get(@translated_type).find(@translated_id)
          translatable.update_all_attributes_translation(@destination_locale, @origin_locale)
        end
        
        
      end 
end

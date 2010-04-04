
module TranslationJobs
      class MachineTranslationJob
        attr_accessor :translated_id, :translated_type#, :origin_locale
        @queue = :file_queue
         def initialize(options)
            self.translated_id = options[:translated_id]
            self.translated_type =  options[:translated_type]
            #self.origin_locale =  options[:origin_locale]
          end
           def self.perform
             translatable = Kernel.const_get(@translated_type).find(@translated_id)
             translatable.update_translations!
            
           end
            def perform 
               self.class.perform

             end
      end
      class AutoTranslateJob 
        attr_accessor :translated_id, :translated_type, :origin_locale, :destination_locale
        @queue = :file_queue
         def initialize(options)
            self.translated_id = options[:translated_id]
            self.translated_type =  options[:translated_type]
            self.origin_locale =  options[:origin_locale]
            self.destination_locale =  options[:destination_locale]
          end
        def self.perform(options = nil)
          translatable = Kernel.const_get(options["translated_type"]).find(options["translated_id"])
          translatable.update_all_attributes_translation(options["destination_locale"], options["origin_locale"])
        end
         def perform 
             self.class.perform

           end
      end 
end
module HasManyTranslations
  
  module Control
    
    def self.included(base) # :nodoc:
      base.class_eval do
        include InstanceMethods
        # alias_method_chain :create_translation?, :control
        #         alias_method_chain :update_translation?, :control
      end
    end
    
    module InstanceMethods
      def force_update
        with_translation_flag(:force_update) do
          yield if block_given?
          save
        end
      end
      def force_update!
        with_translation_flag(:force_update) do
          yield if block_given?
          update_translations!
        end
      end
      
      def force_update?
        !!@force_update
      end
      
      def skip_translation
        with_translation_flag(:skip_translation) do
          yield if block_given?
          save
        end
      end
      
      def skip_translation!
        with_translation_flag(:skip_translation) do
          yield if block_given?
          save!
        end
      end
      
      def skip_translation?
        !!@skip_translation
      end
      
      private
        # Used for each control block, the +with_version_flag+ method sets a given variable to
        # true and then executes the given block, ensuring that the variable is returned to a nil
        # value before returning. This is useful to be certain that one of the control flag
        # instance variables isn't inadvertently left in the "on" position by execution within the
        # block raising an exception.
        def with_translation_flag(flag)
          begin
            instance_variable_set("@#{flag}", !instance_variable_get("@#{flag}"))
            yield
          # ensure
          #             instance_variable_set("@#{flag}", nil)
          end
        end
        
    end
  end
end
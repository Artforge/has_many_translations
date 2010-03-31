module HasManyTranslations
  # Adds the functionality necessary for translation actions on a has_translations instance of
  # ActiveRecord::Base.
  module Creation
    def self.included(base) # :nodoc:
      base.class_eval do
        extend ClassMethods
        include InstanceMethods
        before_update :update_translation?
 
        after_save :update_translations!
        class << self
          alias_method_chain :prepare_translated_options, :creation
        end
      end
    end
    
    # Class methods added to ActiveRecord::Base to facilitate the creation of new translations.
    module ClassMethods
      # Overrides the basal +prepare_has_translations_options+ method defined in HasManyTranslations::Options
      # to extract the <tt>:only</tt> and <tt>:except</tt> options into +has_many_translations_options+.
      def prepare_translated_options_with_creation(options)
        result = prepare_translated_options_without_creation(options)

        self.has_many_translations_options[:only] = Array(options.delete(:only)).map(&:to_s).uniq if options[:only]
        self.has_many_translations_options[:except] = Array(options.delete(:except)).map(&:to_s).uniq if options[:except]
        self.has_many_translations_options[:locales] = Array(options.delete(:locales)).map(&:to_s).uniq if options[:locales]
        result
      end
    end

    # Instance methods that determine whether to save a translation and actually perform the save.
    module InstanceMethods
      #private
        def localize=(loc)
          @locale = loc
        end
        # def hmt_default_locale
        #         return default_locale.to_sym if respond_to?(:default_locale)
        #         return self.class.default_locale.to_sym if self.class.respond_to?(:default_locale)
        #         I18n.default_locale
        #       end
        def hmt_locale
          return self.locale.to_sym if respond_to?(:locale)
          return self.class.locale.to_sym if self.class.respond_to?(:locale)
          I18n.locale
        end
       
        # Returns whether a new translation should be created upon updating the parent record.
        def create_translation?
          #determine if locale parameter is supported by this translated 
          # find out if we have a table created for all locales
          # glob I18n.available_locales with whatever we use for the "study" available_locales
          # I18n.available_locales.include? 
          #!translation_changes.blank?
          true
        end
        def create_translation_for_locale?(locale)
          #determine if locale parameter is supported by this translated 
          # find out if we have a table created for all locales
          # glob I18n.available_locales with whatever we use for the "study" available_locales
          # I18n.available_locales.include? 
          locales = Google::Language::Languages.keys & I18n.available_locales.map{|l|l.to_s}
          locales.include?(locale)
        end

        # Creates a new translation upon updating the parent record.
        def create_translation
          
          translation.create(translation_attributes)
          #reset_translation_changes
          #reset_translation
        end

        # Returns whether the last translation should be updated upon updating the parent record.
        # This method is overridden in HasManyTranslations::Control to account for a control block that
        # merges changes onto the previous translation.
        def update_translations!
           translated_columns.each do |attrib|
              self.locales.each do |loc|
                  update_translation(attrib, loc, self.hmt_locale)
              end
           end
        end
        
        def update_translation?
          unless self.translations.blank? || self.translations.first.origin_locale_code == self.hmt_locale
            dirty_translations = self.translations.all(:conditions => {:translated_id => self.id, :locale_code => self.hmt_locale)
            dirty_translations.each do |dt|
              dt.value = try(dt.attribute)
              dt.save
            end
            return false
          end
        end

        # Updates the last translation's changes by appending the current translation changes.
        def update_translation(attribute, loc, origin_locale)
          unless translations.first(:conditions => {:attribute => attribute, :locale_code => loc.to_s})
            update_translation!(attribute, loc, origin_locale)
          end
        end
        def update_translation!(attribute, loc, origin_locale)
           translated_value = Translate.t(try(attribute), origin_locale, loc.to_s)
           translations.create(:attribute => attribute, :locale_code => loc.to_s, :value => translated_value, :locale_name => Google::Language::Languages[loc.to_s], :machine_translation => true, :origin_locale_code => origin_locale)
        end
        
        
        # Returns an array of column names that should be included in the translation  
        # If <tt>has_many_translations_options[:only]</tt> is specified, only those columns
        # will be translationed. Otherwise, if <tt>has_many_translations_options[:except]</tt> is specified,
        # all columns will be translationed other than those specified. Without either option, the
        # default is to translation all text & string columns. At any rate, the four "automagic" timestamp 
        # columns maintained by Rails are never translationed.
        def translated_columns
          case
            textual_columns = self.class.columns.map{|c|c.type == :string || c.type == :text ? c.name : nil}.compact
            when has_many_translations_options[:only] then textual_columns & has_many_translations_options[:only]
            when has_many_translations_options[:except] then textual_columns - has_many_translations_options[:except]
            else textual_columns
          end - %w(created_at created_on updated_at updated_on)
        end

        def queue_translations
         # Resque.enqueue(Jobs::MachineTranslationJob.new(self.id, self.type))
         job = Jobs::MachineTranslationJob.new(self.id, self.type, self.hmt_locale)
        end
        def locales
          locales = has_many_translations_options[:locales] ? has_many_translations_options[:locales] & Google::Language::Languages.keys : Google::Language::Languages.keys & I18n.available_locales.map{|l|l.to_s}
          # I18n.available_locales.map(&:to_s)
        end
        # Specifies the attributes used during translation creation. This is separated into its own
        # method so that it can be overridden by the HasManyTranslations::Users feature.
        # def translation_attributes
        #           {:changes => translation_changes, :number => last_translation + 1}
        #         end
    end
  end
end
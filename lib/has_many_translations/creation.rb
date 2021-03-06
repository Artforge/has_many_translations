require 'rtranslate'
require 'translation_spec'

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
      #@translator = Translate::RTranslate.new
      # Overrides the basal +prepare_has_translations_options+ method defined in HasManyTranslations::Options
      # to extract the <tt>:only</tt> and <tt>:except</tt> options into +has_many_translations_options+.
      def prepare_translated_options_with_creation(options)
        self.columns.map{|c|c.type == :string || c.type == :text ? c.name : nil}.compact.each{|name|
          #alias_method "#{name}_before_translation", name.to_sym
          #unless try(name)
            define_method name, lambda { |*args|
              #
              if self.translations.blank? || self.translations.first.origin_locale_code == self.hmt_locale || read_attribute(name.to_sym).nil?
                read_attribute(name.to_sym)
              else
                trans = self.translations.first(:conditions => {:locale_code => self.hmt_locale, :model_attribute => name})
                val = trans.nil? ? read_attribute(name.to_sym) : trans.value
                #self.hmt_locale
              end
              #HasManyTranslations.fetch(args.first || self.class.locale || I18n.locale, name)
            }
          
          alias_method "#{name}_before_type_cast", name
          
        }
        
        result = prepare_translated_options_without_creation(options)

        self.has_many_translations_options[:only] = Array(options.delete(:only)).map(&:to_s).uniq if options[:only]
        self.has_many_translations_options[:except] = Array(options.delete(:except)).map(&:to_s).uniq if options[:except]
        self.has_many_translations_options[:locales] = Array(options.delete(:locales)).map(&:to_s).uniq if options[:locales]
        self.has_many_translations_options[:default_languages] = options[:default_languages] ? Array(options.delete(:default_languages)).map(&:to_s).uniq : nil
        self.has_many_translations_options[:languages] = options[:languages] ? Array(options.delete(:languages)).map(&:to_s).uniq : nil
        # self.has_many_translations_options[:force_on_update] = options[:force_on_update] ? Array(options.delete(:force_on_update)).map(&:to_s).uniq : nil
        
        
        result
      end
      
    end

    # Instance methods that determine whether to save a translation and actually perform the save.
    module InstanceMethods
      
      #private
        #attr_accessor :translator
        #@translator = Translate::RTranslate.new
        if defined? Settings
          @translator.key = Settings.google_api_key
        end
        
        # def force_on_update?
        #           return false
        #         end
        
        def allowed_locales
          t = TranslationSpec.first(:conditions => {:translated_id => self.id,  :translated_type  => self.class.to_s})
          t.blank? ? nil : t.codes.split(',').map{|c| c.to_sym}
        end
        
        def locales=(codes)
          t = TranslationSpec.first(:conditions => {:translated_id => self.id,  :translated_type  => self.class.to_s})
          unless t.blank?
            t.update_attribute('codes', codes.map{|c|c.to_s}.join(','))
          else
            TranslationSpec.create(:translated_id => self.id, :translated_type => self.class.to_s, :codes => codes.map{|c|c.to_s}.join(','))
          end
        end
        
        def localize=(loc)
          @locale = loc
        end
        
        
        # def hmt_default_locale
        #         return default_locale.to_sym if respond_to?(:default_locale)
        #         return self.class.default_locale.to_sym if self.class.respond_to?(:default_locale)
        #         I18n.default_locale
        #       end
        def hmt_locale
          @hmt_locale = respond_to?(:locale) ? self.locale.to_s : self.class.respond_to?(:locale) ? self.class.locale.to_s : I18n.locale.to_s
          
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
          locales.include?(locales)
        end

        # Creates a new translation upon updating the parent record.
        def create_translation
          translation.create(translation_attributes)
          #reset_translation_changes
          #reset_translation
        end

        
        def update_translations!
           #translated_columns.each do |attrib|
              self.locales.each do |loc|
                  # put this in a option check blog to determine if the job should be queued? 
                  queue_translation(loc)
                  #ActiveQueue::Queue.enqueue(TranslationJobs::AutoTranslateJob,{:translated_id => self.id,:translated_type  => self.type, :origin_locale =>  self.hmt_locale, :destination_locale => loc.to_s})
                  #update_all_attributes_translation(loc, self.hmt_locale)
              end
           #end
        end
        
        # Returns whether the last translation should be updated upon updating the parent record.
        # This method is overridden in HasManyTranslations::Control to account for a control block that
        # merges changes onto the previous translation.
        def update_translation?
          unless self.translations.blank? || self.translations.first.origin_locale_code == self.hmt_locale
            dirty_translations = self.translations.all(:conditions => {:translated_id => self.id, :locale_code => self.hmt_locale})
            dirty_translations.each do |dt|
              dt.value = try(dt.model_attribute)
              dt.save
            end
            return false
          end
        end

        def update_all_attributes_translation(loc, origin_locale)
          self.translated_columns.each do |attrib|
            update_translation(attrib, loc, origin_locale)
          end
        end
        
        # Updates the last translation's changes by appending the current translation changes.
        def update_translation(attrib, loc, origin_locale)
          if !translations.first(:conditions => {:model_attribute => attrib, :locale_code => loc.to_s}) || self.force_on_update?
            update_translation!(attrib, loc, origin_locale.to_s)
          end
        end
        
        def update_translation!(attrib, loc, origin_locale, options = {})
          @translator ||= ToLang.start(HmtSettings.google_api_key)
          # if defined? HmtSettings
          #              @translator.key = HmtSettings.google_api_key
          #            end
          # translation_val = @translator.translate(try(attrib), :from => origin_locale.to_s, :to => loc.to_s)
          unless (loc.to_s ==  origin_locale.to_s)
            unless try(attrib).nil?
              translation_val = "Awaiting Translation" # try(attrib).translate(loc.to_s, :from => origin_locale.to_s)
              Rails.logger.info("************")
              # Rails.logger.info(attrib)
              Rails.logger.info(translation_val)
              Rails.logger.info(Google::Language::Languages[loc.to_s])
              Rails.logger.info("************")
              unless translation_val.nil? || translation_val.match('Error: ')
                t = translations.where(
                :model_attribute => attrib, 
                :locale_code => loc.to_s, 
                :locale_name => Google::Language::Languages[loc.to_s], 
                :machine_translation => true, 
                :origin_locale_code => origin_locale 
                ).first_or_create
                t.update_attributes({:value => translation_val}) if t.value.blank?
              end
            end
          end
        end
        
        def force_initialize_translation!(attrib, loc, origin_locale, options = {})
          @translator ||= ToLang.start(HmtSettings.google_api_key)
          # if defined? HmtSettings
          #              @translator.key = HmtSettings.google_api_key
          #            end
          # translation_val = @translator.translate(try(attrib), :from => origin_locale.to_s, :to => loc.to_s)
          unless (loc.to_s ==  origin_locale.to_s)
            # unless try(attrib).nil?
              # translation_val = try(attrib).translate(loc.to_s, :from => origin_locale.to_s)
              # unless translation_val.nil? || translation_val.match('Error: ')
                t = translations.where(
                :model_attribute => attrib, 
                :locale_code => loc.to_s, 
                :locale_name => Google::Language::Languages[loc.to_s], 
                :machine_translation => true, 
                :origin_locale_code => origin_locale 
                ).first_or_create
                # t.update_attributes({:value => translation_val, })
              # end
            # end
          end
        end
        
        def force_initialize_translations!(loc, origin_locale)
          translated_columns.each do |attrib|
            force_initialize_translation!(attrib, loc, origin_locale)
          end
        end
        
        
        # Returns an array of column names that should be included in the translation  
        # If <tt>has_many_translations_options[:only]</tt> is specified, only those columns
        # will be translationed. Otherwise, if <tt>has_many_translations_options[:except]</tt> is specified,
        # all columns will be translationed other than those specified. Without either option, the
        # default is to translation all text & string columns. At any rate, the four "automagic" timestamp 
        # columns maintained by Rails are never translationed.
        def translated_columns
          textual_columns = self.class.columns.map{|c|c.type == :string || c.type == :text ? c.name : nil}.compact
          
          if self.has_many_translations_options[:except] 
            textual_columns = textual_columns - self.has_many_translations_options[:except]
          elsif self.has_many_translations_options[:only] 
            textual_columns = textual_columns & self.has_many_translations_options[:only]
          end
          
          return textual_columns
        end
        
        def queue_translation(loc)
          #ActiveQueue::Job.new(:val => { :translated_id => self.id, :translated_type => self.class.to_s, :origin_locale => self.hmt_locale, :destination_locale => loc },:job_klass => "TranslationJobs::AutoTranslateJob",:adapter => HmtSettings.queue_type).enqueue
          ActiveQueue::Job.new(:val => { :translated_id => self.id, :translated_type => self.class.to_s, :origin_locale => self.hmt_locale, :destination_locale => loc },:job_klass => "TranslationJobs::AutoTranslateJob",:adapter => "insta").enqueue
        end
        
        def queue_translations
          self.locales.each do |loc|
            queue_translation(loc)
          end
        end
        
        def locales
          if allowed_locales
            retloc = has_many_translations_options[:default_locales] ? (has_many_translations_options[:default_locales] & allowed_locales.map{|l|l.to_s}) : allowed_locales.map{|l|l.to_s}
          elsif super_locales.present? 
            super_locales.each do |sloc|
              retloc.nil? ? retloc = eval("self.#{sloc}.locales") : retloc | eval("self.#{sloc}.locales")
            end
          end
          retloc ||= (has_many_translations_options[:locales] && I18n && Google) ? (has_many_translations_options[:locales] & Google::Language::Languages.keys) : (Google::Language::Languages.keys & I18n.available_locales.map{|l|l.to_s})
          if has_many_translations_options[:languages]
            retloc = retloc.empty? ? has_many_translations_options[:languages] : (has_many_translations_options[:languages] & retloc) 
          end
          # I18n.available_locales.map(&:to_s)
        end
        
        def super_locales 
          if I18n && Google
            self.class.reflect_on_all_associations(:belongs_to).map{|a|eval("#{a.name.to_s.capitalize}.translated?") ? a.name.to_s : nil}.compact
          end
        end
        # Specifies the attributes used during translation creation. This is separated into its own
        # method so that it can be overridden by the HasManyTranslations::Users feature.
        # def translation_attributes
        #           {:changes => translation_changes, :number => last_translation + 1}
        #         end
    end
  end
end
module HasManyTranslations
  # Adds the functionality necessary for translation actions on a has_translations instance of
  # ActiveRecord::Base.
  module Creation
    def self.included(base) # :nodoc:
      base.class_eval do
        extend ClassMethods
        include InstanceMethods

        after_update :create_translation, :if => :create_translation?

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

        self.has_many_translations_options_options[:only] = Array(options.delete(:only)).map(&:to_s).uniq if options[:only]
        self.has_many_translations_options_options[:except] = Array(options.delete(:except)).map(&:to_s).uniq if options[:except]

        result
      end
    end

    # Instance methods that determine whether to save a translation and actually perform the save.
    module InstanceMethods
      private
        # Returns whether a new translation should be created upon updating the parent record.
        def create_translation?
          !translation_changes.blank?
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
        def update_translation?
          false
        end

        # Updates the last translation's changes by appending the current translation changes.
        def update_translation
          return create_translation unless t = translations.last
          t.changes_will_change!
          t.update_attribute(:changes, t.changes.append_changes(translation_changes))
          #reset_translation_changes
          #reset_translation
        end

        # Returns an array of column names that should be included in the changes of created
        # translations. If <tt>has_many_translations_options[:only]</tt> is specified, only those columns
        # will be translationed. Otherwise, if <tt>has_many_translations_options[:except]</tt> is specified,
        # all columns will be translationed other than those specified. Without either option, the
        # default is to translation all text & string columns. At any rate, the four "automagic" timestamp 
        # columns maintained by Rails are never translationed.
        def translated_columns
          case
            textual_columns = self.class.columns.map{|c|c.type == :string || c.type == :text ? c.name : nil}.compact
            when translated_options[:only] then textual_columns & translated_options[:only]
            when translated_options[:except] then textual_columns - translated_options[:except]
            else textual_columns
          end - %w(created_at created_on updated_at updated_on)
        end

        # Specifies the attributes used during translation creation. This is separated into its own
        # method so that it can be overridden by the HasManyTranslations::Users feature.
        # def translation_attributes
        #           {:changes => translation_changes, :number => last_translation + 1}
        #         end
    end
  end
end
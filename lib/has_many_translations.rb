Dir[File.join(File.dirname(__FILE__), 'has_many_translations', '*.rb')].each{|f| require f }

require 'to_lang'
require 'activequeue'

# The base module that gets included in ActiveRecord::Base. See the documentation for
# HasManyTranslations::ClassMethods for more useful information.
module HasManyTranslations
  
  
  def self.included(base) # :nodoc:
    base.class_eval do
      extend ClassMethods
      extend Translated
    end
  end
  
  module ClassMethods
    def translated(options = {}, &block)
      return if translated?
      
      include Options
      include TranslationJobs
      include Creation
      include Control
      include Translations
      prepare_translated_options(options)
      has_many :translations, options.merge({:order => "translations.updated_at DESC"}), &block
      
    end
    
  end
  
  extend Configuration
  
end

ActiveRecord::Base.send(:include, HasManyTranslations)
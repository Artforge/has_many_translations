class HmtSettings
  @@google_api_key = ""
  @@languages = []
  @@default_languages = []
  @@force_on_update = false
  
  def self.google_api_key=(key)
    @@google_api_key = key
  end
  def self.google_api_key
    @@google_api_key
  end
  def self.languages=(langs)
    @@languages = langs
  end
  def self.languages
    @@languages
  end
  def self.default_languages=(langs)
    @@default_languages = langs
  end
  def self.default_languages
    @@default_languages
  end
  def self.force_on_update=(key)
    @@force_on_update = key
  end
  def self.force_on_update
    @@force_on_update
  end
end
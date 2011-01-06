class HmtSettings
  @@google_api_key = ""
  @@languages = []
  @@default_languages = []
  
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
end
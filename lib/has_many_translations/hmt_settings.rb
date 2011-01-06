class HmtSettings
  @@google_api_key = ""
  def self.google_api_key=(key)
    @@google_api_key = key
  end
  def self.google_api_key
    @@google_api_key
  end
  
end
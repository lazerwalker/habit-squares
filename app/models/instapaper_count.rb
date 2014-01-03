require 'instapaper'

class InstapaperCount < DataSource
  after_initialize :authenticate

  @show_count = true
  @description = "Have I emptied my Instapaper queue?"

  def updated_count
    Instapaper.bookmarks(limit: 500).count
  end

  def green
    self.count == 0
  end

  private

  def authenticate
    api_config = YAML.load(File.open('./config/externals.yml'))['instapaper']

    Instapaper.configure do |config|
      config.consumer_key = api_config["consumer_key"]
      config.consumer_secret = api_config["consumer_secret"]
      config.oauth_token = api_config["oauth_token"]
      config.oauth_token_secret = api_config["oauth_token_secret"]
    end
  end
end
require "dropbox_sdk"

class DropboxJournal < DataSource
  @description = "Have I written in my journal today?"

  def is_green?
    filename = date.strftime("%Y-%m-%d.md")
    client.search("/Journal", filename).length > 0
  end

  private

  def config
    @config ||= YAML.load(File.open('./config/externals.yml'))['dropbox']
  end

  def client
    @client ||= DropboxClient.new(config["access_token"])
  end

end
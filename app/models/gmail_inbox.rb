require 'gmail'
class GmailInbox < DataSource
  @show_count = false
  @description = "Have I reached Inbox Zero today?"

  def updated_count
    client.inbox.count
  end

  def is_green?
    count.to_i == 0 || self.green || false
  end

  private

  def client
    unless @client
      config = YAML.load(File.open('./config/externals.yml'))['gmail']
      @client = Gmail.new(config["username"], config["password"])
    end

    @client
  end
end
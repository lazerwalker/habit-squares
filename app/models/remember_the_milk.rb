require 'milkman'

class RememberTheMilk < DataSource
  @show_count = true
  @description = "Is my to-do list empty?"

  def updated_count
    binding.pry
    tasks = client.get("rtm.tasks.getList", list_id: list_id)
    tasks = tasks["rsp"]["tasks"]["list"]["taskseries"]
    tasks.reject! do |t|
      !t["task"]["completed"].empty? ||
      !t["task"]["deleted"].empty? ||
      !t["task"]["due"].empty? && Date.parse(t["task"]["due"]) > Date.today
    end

    tasks.count
  end

  def is_green?
    count == 0
  end

  private

  def list_id
    unless @list
      lists = client.get("rtm.lists.getList")["rsp"]["lists"]["list"]
      @list = lists.select { |l| l["name"] == config["list"] }.first
    end
    @list["id"]
  end

  def config
    @config ||= YAML.load(File.open('./config/externals.yml'))['remember_the_milk']
  end

  def client
    @client ||= Milkman::Client.new(
      api_key: config["api_key"],
      shared_secret: config["shared_secret"],
      auth_token: config["auth_token"]
    )
  end
end
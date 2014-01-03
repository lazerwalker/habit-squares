class Duolingo < DataSource
  include HTTParty
  base_uri 'http://duolingo.com/users'

  @description = "Have I studied French today?"

  def is_green?
    config = YAML.load(File.open('./config/externals.yml'))

    username = config['duolingo']['username']
    res = self.class.get("/#{username}")

    timestamp = res['language_data'].values[0]["calendar"][-1]["datetime"] / 1000
    last_date = adjusted_date Time.at(timestamp)
    return (last_date == date)
  end
end
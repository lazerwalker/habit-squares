class FitbitClient
  # Adapted from 'fitgem-sandbox'
  def initialize
    config = begin
      conf = YAML.load(File.open("./config/externals.yml"))['fitbit']
      Fitgem::Client.symbolize_keys(conf)
    rescue ArgumentError => e
      puts "Could not parse YAML: #{e.message}"
      exit
    end

    @client = Fitgem::Client.new(config)

    if config[:token] && config[:secret]
      begin
        access_token = @client.reconnect(config[:token], config[:secret])
      rescue Exception => e
        puts "Error: Could not reconnect Fitgem::Client due to invalid keys in .fitgem.yml"
        exit
      end
    else
      request_token = @client.request_token
      token = request_token.token
      secret = request_token.secret

      puts "Go to http://www.fitbit.com/oauth/authorize?oauth_token=#{token} and then enter the verifier code below"
      verifier = gets.chomp

      begin
        access_token = @client.authorize(token, secret, { :oauth_verifier => verifier })
      rescue Exception => e
        puts "Error: Could not authorize Fitgem::Client with supplied oauth verifier"
        exit
      end
      user_id = @client.user_info['user']['encodedId']

      config.merge!(:token => access_token.token, :secret => access_token.secret, :user_id => user_id)
        File.open(".fitgem.yml", "w") {|f| f.write(config.to_yaml) }
    end
  end

  def fetch_for_date(date, uri)
    hash = @client.data_by_time_range(uri, base_date: date, period: '1d')
    key = hash.keys.first
    hash[key][0]["value"] || 0
  end
end
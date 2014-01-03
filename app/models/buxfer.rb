require 'httparty'

class Buxfer < DataSource
  include HTTParty
  base_uri 'http://buxfer.com/api'
  format :json

  @description = "Am I spending too much money?"

  def is_green?
    get_auth_token

    res = self.class.get("/budgets.json")

    budget = res['response']['budgets'][0]['key-budget']
    limit = budget['limit']
    spent = (limit - budget['balance'])
    budget_ratio = spent / limit

    days_in_month = Date.new(date.year, date.month, -1).day
    date_ratio = date.day.to_f / days_in_month

    date_ratio > budget_ratio
  end

  def get_auth_token
    return if @token

    config = YAML.load(File.open('./config/externals.yml'))['buxfer']

    # Passing in a params hash causes @ to get sanitized, which Buxfer rejects
    params = "userid=#{config['username']}&password=#{config['password']}"

    response = self.class.get("/login.json", query: params)
    if response['response']['status'] == 'OK'
      @token = response['response']['token']
      self.class.default_params(token: @token)
    end
  end
end
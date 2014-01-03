class FitbitDistance < DataSource
  @show_count = true
  @description = "Have I walked enough today?"
  @unit = "mi"

  def updated_count
    "%0.1f" % client.fetch_for_date(date, '/activities/log/distance')
  end

  def is_green?
    count.to_i >= 5
  end

  def client
    @client ||= FitbitClient.new
  end
end
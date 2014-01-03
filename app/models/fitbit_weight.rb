class FitbitWeight < DataSource
  @show_count = true
  @description = "Did I weigh myself today?"
  @unit = "lbs"

  def is_green?
    @count.to_i >= 5
  end

  def weight
    @weight ||= "%.1f" % client.fetch_for_date(date, '/body/weight')
  end

  def fat
    @fat ||= "%.1f" % client.fetch_for_date(date, '/body/fat')
  end

  def is_green?
    fat != "0.0"
  end

  def updated_count
    weight
  end

  private

  def client
    @client ||= FitbitClient.new
  end

end
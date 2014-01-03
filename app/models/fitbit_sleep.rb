class FitbitSleep < DataSource
  @show_count = true
  @description = "Did I get enough sleep last night?"

  def updated_count
    "%d:%02d" % [hours, minutes]
  end

  def is_green?
    (total_minutes.to_f / 60) >= 7.4
  end

  private

  def total_minutes
    @minutes ||= client.fetch_for_date(date, '/sleep/timeInBed').to_i
  end

  def minutes
    total_minutes % 60
  end

  def hours
    total_minutes / 60
  end

  def client
    @client ||= FitbitClient.new
  end
end
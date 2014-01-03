class DataSource < ActiveRecord::Base
  attr_accessible :date, :green, :count

  class << self
    attr_accessor :show_count, :description, :unit

    def for_today
      object = self.find_or_create_by_date(today)
      object.refetch if object.updated_at < Time.now - 1.minute
      object
    end

    def adjusted_date(time)
      if time.hour < 5
        time -= 12 * 60 * 60
      end
      time.to_date
    end

    def today
      adjusted_date(Time.now)
    end
  end

  def adjusted_date(time)
    self.class.adjusted_date(time)
  end

  def history
    last_week = self.class.where(:date => (self.date - 6.days)...(self.date))
    last_week.map(&:green).compact.reverse
  end

  def updated_count
    nil
  end

  def is_green?
    false
  end

  def refetch
    self.count = updated_count
    self.green = is_green?
    save
  end

  def as_json(opts={})
    {
      description: self.class.description,
      show_count: self.class.show_count || false,
      unit: self.class.unit,
      date: date,
      green: green,
      count: count,
      history: history
    }.reject {|k, v| v.nil?}
  end

  private


end
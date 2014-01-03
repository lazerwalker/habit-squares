class TappableDataSource < DataSource
  def is_green?
    self.green
  end

  def as_json(opts={})
    json = super(opts)
    tappable = { tappable: true }
    json.merge tappable
  end
end
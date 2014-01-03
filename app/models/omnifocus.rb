# A WORD OF WARNING:
# This data source must be run on an OS X machine with OmniFocus installed

class Omnifocus < DataSource
  def updated_count
    `osascript ./osa/omnifocus-count.scpt`.to_i
  end

  def is_green?
    count == 0
  end
end
require 'nokogiri'
require 'open-uri'

class SevenFiftyWords < DataSource
  @description = "Did I write in my journal today?"

  def is_green?
    config = YAML.load(File.open('./config/externals.yml'))

    url = config['750words']['rss']
    doc = Nokogiri::HTML(open(url))

    today = Time.now
    if today.hour < 5
      today -= 12 * 60 * 60
    end

    todayString = today.strftime("%a, %d %b %Y")
    doc.css('item pubdate').each do |date|
      if date.content.include?(todayString)
        return true
      end
    end

    return false
  end
end
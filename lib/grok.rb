class Grok

  def self.get_all_views_for_article(title, start=nil)
    total = 0
    if start.nil?
      start = CourseList.start.to_date
    end
    start_print = start.strftime("%d-%m-%y")
    puts "Calculating views for #{title} from #{start_print}"
    while Date.today >= start do
      total += self.get_month_views_for_article(title, start.strftime("%Y%m"))
      start += 1.month
    end
    total
  end

  def self.get_month_views_for_article(title, month=nil)
    if month.nil?
      month = Date.today.strftime("%Y%m")
    end
    data = Grok.api_get(title, month)
    data = JSON.parse data
    total = 0
    data["daily_views"].each do |day, views|
      total += views
    end
    total
  end

  def self.get_day_views_for_article(title, date)
    data = Grok.api_get(title, date.strftime("%Y%m"))
    data = JSON.parse data
    data["daily_views"][date.strftime("%Y-%m-%d")]
  end


  private

  def self.api_get(title, month)
    title = URI.escape(title)
    url = "http://stats.grok.se/json/en/#{month}/#{title}"
    Net::HTTP::get(URI.parse(url))
  end

end
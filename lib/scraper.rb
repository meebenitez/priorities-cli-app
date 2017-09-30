require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  ##################SCRAPING##############################

    def self.grab_cities(url_hash)#and populations
      cities = {}
      url_hash.each do |state, state_url|
        counter = 0
        doc = Nokogiri::HTML(open(state_url))
        if state == "California"
          data = doc.css("div.section-content").css("tbody[data-reactid='191']").css("td")
        elsif state == "Georgia" || state == "Kentucky" || state == "Montana" || state == "Vermont" || state == "Alaska"
          data = doc.css("div.section-content").css("tbody[data-reactid='167']").css("td")
        elsif state == "Idaho" || state == "Indiana" || state == "Tennessee" || state == "Virginia" || state == "Wisconsin"
          data = doc.css("div.section-content").css("tbody[data-reactid='175']").css("td")
        elsif state == "Hawaii"
          data = doc.css("div.section-content").css("tbody[data-reactid='103']").css("td")
        else
          data = doc.css("div.section-content").css("tbody[data-reactid='183']").css("td")
        end
        total_count = data.count - 1
        until counter > total_count
          counter.even? ? city_name = data[counter].text : city_population = data[counter].text
          city_name = city_name.sub(" village", '')
          cities.merge!({city_name => {population: city_population, state_name: state}})
          counter += 1
        end
      end
        cities
    end

    def self.grab_home_prices(index_url)
      begin
        sleep(1.5) #polite 1 second wait before the next traffic hit
        doc = Nokogiri::HTML(open(index_url))
        price = doc.css("section#median-income div.hgraph")[1].css("td")[1].text
      end
      rescue OpenURI::HTTPError => e
        if e.message == '404 Not Found' || e.message == "404 NOT FOUND"
          puts "-->"
        else
          raise e
        end
    end


    def self.grab_diversity(index_url)
      begin
        sleep(1.5) #polite 1 second wait before the next traffic hit
        doc = Nokogiri::HTML(open(index_url))
        white_population = doc.css("section.demographics.profile-section article.topic div.content aside div.topic-stats div.stat div.stat-value.stat-small span.stat-right span.stat-subtitle span.stat-span").first.text
      end
    rescue OpenURI::HTTPError => e
      if e.message == '404 Not Found' || e.message == "404 NOT FOUND"
        puts "-->"
      else
        raise e
      end
    end

    def self.grab_education(index_url)
      begin
        sleep(1.5) #polite 1 second wait before the next traffic hit
        doc = Nokogiri::HTML(open(index_url))
        percent = doc.css("section#education-info").css("ul").css("li")[1].text.sub("Bachelor's degree or higher: ", "")
      end
    rescue OpenURI::HTTPError => e
      if e.message == '404 Not Found' || e.message == "404 NOT FOUND"
        puts "-->"
      else
        raise e
      end
    end

    def self.grab_median_income(index_url)
      begin
        sleep(1.5) #polite 1 second wait before the next traffic hit
        doc = Nokogiri::HTML(open(index_url))
        median_income = doc.css("section#median-income div.hgraph").css("td")[1].textw
      end
    rescue OpenURI::HTTPError => e
      if e.message == '404 Not Found' || e.message == "404 NOT FOUND"
        puts "-->"
      else
        raise e
      end
    end

    def self.grab_majority_voters(index_url)
      begin
        sleep(1.5) #polite 1 second wait before the next traffic hit
        doc = Nokogiri::HTML(open(index_url))
        republican = doc.css("div.span6").css("div")[6].css("div")[3].css("tr").css("td")[5]
        democrat = doc.css("div.span6").css("div")[6].css("div")[3].css("tr").css("td")[2]
        independent = doc.css("div.span6").css("div")[6].css("div")[3].css("tr").css("td")[8]
        voter_hash = {"Republican" => republican.text.tr('%', '').to_f, "Democrat" => democrat.text.tr('%', '').to_f, "Independent" => independent.text.tr('%', '').to_f}
      end
      rescue OpenURI::HTTPError => e
      if e.message == '404 Not Found' || e.message == "404 NOT FOUND"
        puts "-->"
      else
        raise e
      end
    end

    def self.grab_crime_stats(index_url)
      sleep(1.5) #polite 1 second wait before the next traffic hit
      begin
        doc = Nokogiri::HTML(open(index_url))
        crime_stat = doc.css("table.av-default.crime-cmp").css("tr.summary.major").css("td")[3].text
        if crime_stat
          crime_stat = crime_stat.sub(' (estimate)', '')
        end
      end
    rescue OpenURI::HTTPError => e
      if e.message == '404 Not Found' || e.message == "404 NOT FOUND"
        puts "-->"
      else
        raise e
      end
    end



##################GENERATING URLS###########################
  def self.create_state_urls(state)
    url_hash = { state => create_worldpop_url(state)}
  end

  def self.create_datausa_url(city_name, state_short)
    city_name = check_and_convert_name_dash(city_name)
    data_url = "https://datausa.io/profile/geo/#{city_name.downcase}-#{state_short.downcase}/"
    data_url
  end

  def self.create_worldpop_url(state_name)
    state_name = check_and_convert_name_dash(state_name)
    data_url = "http://worldpopulationreview.com/states/#{state_name.downcase}-population/cities/"
    data_url
  end

  def self.create_greatschools_url(city_name, state_long)
    city_name = check_and_convert_name_underscore(city_name)
    data_url = "https://www.greatschools.org/#{state_long.downcase}/#{city_name.downcase}/"
    data_url
  end

  def self.create_city_data_url(city_name, state_long)
    city_name = check_and_convert_name_dash(city_name)
    state_long = check_and_convert_name_dash(state_long)
    data_url = "http://www.city-data.com/city/#{city_name}-#{state_long}.html"
    data_url
  end

  def self.create_geostat_url(city_name, state_short)
    city_name = city_name.sub(/\s[a-z].+/, '')
    city_name = check_and_convert_name_dash(check_and_convert_period_name(city_name))
    data_url = "http://www.geostat.org/data/#{city_name}-#{state_short}/voting"
    data_url
  end

  def self.create_areavibes_url(city_name, state_short)
    city_name = check_and_convert_name_dash(check_and_convert_period_name_plus(city_name))
    data_url = "http://www.areavibes.com/#{city_name}-#{state_short}/crime/"
    data_url
  end


#--------------FORMATTING HELP---------------

  def self.check_and_convert_name_dash(name)
    name = name.gsub(' ', '-')
  end

  def self.check_and_convert_period_name(name)
    name = name.gsub('.','')
  end

  def self.check_and_convert_period_name_plus(name)
    name = name.gsub('. ', '.+')
  end

  def self.check_and_convert_name_underscore(name)
    if name.include?(" ")
      name = name.gsub!(' ', '-')
    elsif name.include?("-")
      name = name.gsub!(' ', '_')
    else
      name
    end
    name
  end


####################REGION CODE############################
#def self.create_state_urls(input)
#  url_hash = {}
#  City.regions(input).each { |state| url_hash.merge!({state => create_worldpop_url(state)}) }
#  url_hash
#end
#############################################################


end

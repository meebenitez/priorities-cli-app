require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'
require 'pry'

class Scraper

  ##################SCRAPING##############################

    def self.grab_cities(url_hash)#and populations
      cities = {}
      url_hash.each do |state, state_url|
        #binding.pry
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
          cities.merge!({city_name => {population: city_population, state_name: state}})
          counter += 1
        end
      end
        cities
    end

    def self.grab_home_prices(index_url)
      begin
        doc = Nokogiri::HTML(open(index_url))
        price = doc.css("section#median-income div.hgraph").css("td")[1].text
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
        doc = Nokogiri::HTML(open(index_url))
        median_income = doc.css("section#median-income div.hgraph").css("td")[1].text
      end
    rescue OpenURI::HTTPError => e
      if e.message == '404 Not Found' || e.message == "404 NOT FOUND"
        puts "-->"
      else
        raise e
      end
    end



    def self.grab_safety(index_url="http://www.usa.com/rank/washington-state--crime-index--city-rank.htm")
      doc = Nokogiri::HTML(open(index_url))
      cities = {}
      counter = 4
      total_count = doc.css("div#hcontent").css("table").css("td").count - 1
      until counter > total_count
          crime_index = doc.css("div#hcontent").css("table").css("td")[counter].text
          city_name = doc.css("div#hcontent").css("table").css("td")[counter + 1].text.gsub((/,.+/), "")
          cities.merge!({city_name => crime_index})
          counter += 3
      end
      cities
    end


##################GENERATING URLS###########################
  def self.create_state_urls(state)
    url_hash = { state => create_worldpop_url(state)}
  end

  def self.create_datausa_url(city_name, state_short)
    city_name = check_and_convert_name_dash(city_name)
    data_url = "https://datausa.io/profile/geo/#{city_name.downcase}-#{state_short.downcase}/"
    #binding.pry
    data_url
  end

  def self.create_worldpop_url(state_name)
    state_name = check_and_convert_name_dash(state_name)
    data_url = "http://worldpopulationreview.com/states/#{state_name.downcase}-population/cities/"
    data_url
      #  binding.pry
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

#--------------FORMATTING HELP---------------

  def self.check_and_convert_name_dash(name)
    name = name.gsub(' ', '-') if name.include?(" ")
    name
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
  #binding.pry
#  url_hash
#end
#############################################################


end

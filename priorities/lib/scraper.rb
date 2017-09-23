require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper




  def self.generate_state_urls(input = "West")
    ####POLISH ---- THIS METHOD NEEDS REDUCTION
    #Creates a hash of urls to push into to 'grab_cities' based on user input
    #Hard-coded regions###########################################################################
    northern_rockies = ["Montana", "Idaho", "Wyoming", "North Dakota", "South Dakota", "Nebraska"]
    southern_rockies = ["Utah", "Colorado", "New Mexico", "Arizona"]
    south_central = ["Texas", "Oklahoma", "Kansas", "Missouri", "Arkansas", "Louisiana"]
    southeast = ["Mississippi", "Alabama", "Georgia", "Florida", "South Carolina", "North Carolina", "Tennessee", "Kentucky", "Virginia", "West Virginia"]
    north_central = ["Minnesota", "Iowa", "Wisconsin", "Illinois", "Indiana", "Michigan", "Ohio"]
    northeast = ["Maine", "New Hampshire", "Vermont", "Massachusetts", "Rhode Island", "New York", "Connecticut", "Pennsylvania", "New Jersey", "Delaware", "Maryland"]
    west = ["Washington", "California", "Oregon", "Nevada"]
    ##############################################################################################
    url_hash = {}
    #####POLISH consider making regions a nested array and then iterating through to avoid all of this if/else nonsense
    if input == "Northern Rockies"
      northern_rockies.each { |state| url_hash.merge!({state => create_worldpop_url(state)}) }
    elsif input == "Southern Rockies"
      southern_rockies.each { |state| url_hash.merge!({state => create_worldpop_url(state)}) }
    elsif input == "South Central"
      south_central.each { |state| url_hash.merge!({state => create_worldpop_url(state)}) }
    elsif input == "Southeast"
      southeast.each { |state| url_hash.merge!({state => create_worldpop_url(state)}) }
    elsif input == "North Central"
      north_central.each { |state| url_hash.merge!({state => create_worldpop_url(state)}) }
    elsif input == "Northeast"
      northeast.each { |state| url_hash.merge!({state => create_worldpop_url(state)}) }
    elsif input == "West"
      west.each { |state| url_hash.merge!({state => create_worldpop_url(state)}) }
    end
    url_hash
  end


  def self.grab_cities(url_hash)
#    def self.grab_cities(url_hash)
    #return hash of cities
    cities = {}
    url_hash.each do |state, state_url|
      counter = 0
      doc = Nokogiri::HTML(open(state_url))
      data = doc.css("div.section-content").css("tbody[data-reactid='183']").css("td")
      total_count = data.count - 1
      until counter > total_count
        counter.even? ? city_name = data[counter].text : city_population = data[counter].text
        cities.merge!({city_name => {population: city_population, state_name: state}})
        counter += 1
      end
    end
      cities
  end



  def self.grab_bio(index_url)
  end


  def self.grab_home_prices(index_url)
    doc = Nokogiri::HTML(open(index_url))
    price = doc.css("section.housing.profile-section article.topic div.content aside div.topic-stats div.stat div.stat-value span.stat-right span.stat-span")[2].text
    price
  end

  def self.grab_diversity(index_url)
    #us average of white people is 63%
    doc = Nokogiri::HTML(open(index_url))
    white_population = doc.css("section.demographics.profile-section article.topic div.content aside div.topic-stats div.stat div.stat-value.stat-small span.stat-right span.stat-subtitle span.stat-span").first.text
    white_population
  end


  def self.grab_averages
    #average home price
    #average white people
    #average crime index

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

  def self.grab_school(index_url)
    doc = Nokogiri::HTML(open(index_url))
    #school_rating =
  end

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

  def self.create_greatschools_url(city_name, state_long)
    city_name = check_and_convert_name_underscore(city_name)
    data_url = "https://www.greatschools.org/#{state_long.downcase}/#{city_name.downcase}/"
    data_url
  end


  def self.create_datausa_url(city_name, state_short)
    city_name = check_and_convert_name_dash(city_name)
    data_url = "https://datausa.io/profile/geo/#{name.downcase}-#{state_short.downcase}/"
    data_url
  end

  def self.create_worldpop_url(state_name)
    state_name = check_and_convert_name_dash(state_name)
    data_url = "http://worldpopulationreview.com/states/#{state_name.downcase}-population/cities/"
    data_url
  end



end

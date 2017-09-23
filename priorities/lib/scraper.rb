require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper





  def self.generate_state_urls
    #use check_and_convert_name
    #url_hash = {}
  #  northern_rockies = ["Montana", "Idaho", "Wyoming", "North Dakota", "South Dakota", "Nebraska"]
  #  southern_rockies = ["Utah", "Colorado", "New Mexico", "Arizona"]
  #  alaska = ["Alaska"]
  #  hawaii = ["Hawaii"]
  #  south_central = ["Texas", "Oklahoma", "Kansas", "Missouri", "Arkansas", "Louisiana"]
  #  southeast = ["Mississippi", "Alabama", "Georgia", "Florida", "South Carolina", "North Carolina", "Tennessee", "Kentucky", "Virginia", "West Virginia"]
  #  north_central = ["Minnesota", "Iowa", "Wisconsin", "Illinois", "Indiana", "Michigan", "Ohio"]
  #  northeast = ["Maine", "New Hampshire", "Vermont", "Massachusetts", "Rhode Island", "New York", "Connecticut", "Pennsylvania", "New Jersey", "Delaware", "Maryland"]

    #output should {state_name => url}
  end
  #"http://worldpopulationreview.com/states/washington-population/cities/"

  def self.grab_cities
#    def self.grab_cities(url_hash)
  url_hash = {"Alaska" => "http://worldpopulationreview.com/states/alaska-population/cities/",
              "Alabama" => "http://worldpopulationreview.com/states/alabama-population/cities/"
              }
    #return hash of cities
    cities = {}
    counter = 0
    url_hash.each do |state, state_url|
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

  def self.create_greatschools_url(name)
    name = check_and_convert_name_underscore(name)
    data_url = "https://www.greatschools.org/washington/#{name.downcase}/"
    data_url
  end


  def self.create_datausa_url(name, state_short)
    name = check_and_convert_name_dash(name)
    data_url = "https://datausa.io/profile/geo/#{name.downcase}-#{state_short.downcase}/"
    data_url
  end

  def self.create_worldpop_url(name)
    name = check_and_convert_name_dash(name)
    data_url = "http://worldpopulationreview.com/states/#{name.downcase}-population/cities/"
    data_url
  end



end

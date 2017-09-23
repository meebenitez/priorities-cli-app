require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.grab_cities(index_url = "http://worldpopulationreview.com/states/washington-population/cities/")
    #return hash of cities
    cities = {}
    counter = 0
    doc = Nokogiri::HTML(open(index_url))
    data = doc.css("div.section-content").css("tbody[data-reactid='183']").css("td")
    total_count = data.count - 1
    until counter > total_count
      if counter.even?
        city_name = data[counter].text
      else
        city_population = data[counter].text
      end
      cities.merge!({city_name => {population: city_population}})
      counter += 1
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

  def self.check_and_convert_name(name)
    name = name.gsub(' ', '-') if name.include?(" ")
    name
  end

  def self.check_and_convert_name_schools(name)
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
    name = check_and_convert_name_schools(name)
    data_url = "https://www.greatschools.org/washington/#{name.downcase}/"
    data_url
  end


  def self.create_datausa_url(name)
    name = check_and_convert_name(name)
    data_url = "https://datausa.io/profile/geo/#{name.downcase}-wa/"
    data_url
  end






end

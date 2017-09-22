class City

  attr_accessor :name, :avg_home_price, :diversity_percent, :population, :crime_index, :school_score, :power_switch, :state_short, :state_long, :bio

  @@all = []

  @@turned_off = []

  def self.all
    @@all
  end

  def self.on_count
    count = 0
    @@all.each do |city|
      if city.power_switch == "on"
        count += 1
      end
    end
    count
  end

  def self.reset_last
    @@turned_off.each do |city|
      city.power_switch = "on"
    end
  end

  def self.destroy_turned_off
    @@turned_off.clear
  end

  def create_city(city, cities_hash)
    city_obj = self.new
    city_obj.name = city[0]
    city_obj.population = cities_hash[city[0]][:population]
    city_obj.power_switch = "on"
    @@all << city_obj
  end


  def self.check_population
    input = gets.strip
    cities_hash = {}
    cities_hash = Scraper.grab_cities
    #puts cities_hash
    ##############LOOK INTO SEND METHOD#########################
    cities_hash.each do |city|
      if input == "1"
        if cities_hash[city[0]][:population].tr(',', '').to_i > 150000
          city_obj = self.new
          city_obj.name = city[0]
          city_obj.population = cities_hash[city[0]][:population]
          city_obj.power_switch = "on"
          @@all << city_obj
        end
      elsif input == "2"
        if cities_hash[city[0]][:population].tr(',', '').to_i > 50000
          city_obj = self.new
          #puts city[0]
          city_obj.name = city[0]
          city_obj.population = cities_hash[city[0]][:population]
          city_obj.power_switch = "on"
          @@all << city_obj
        end
      elsif input == "3"
        if cities_hash[city[0]][:population].tr(',', '').to_i > 5000 && cities_hash[city[0]][:population].tr(',', '').to_i < 50000
          city_obj = self.new
          #puts city[0]
          city_obj.name = city[0]
          city_obj.population = cities_hash[city[0]][:population]
          city_obj.power_switch = "on"
          @@all << city_obj
        end
      elsif input == "4"
        if cities_hash[city[0]][:population].tr(',', '').to_i < 5000
          city_obj = self.new
          #puts city[0]
          city_obj.name = city[0]
          city_obj.population = cities_hash[city[0]][:population]
          city_obj.power_switch = "on"
          @@all << city_obj
        end
      else
        puts "Looks like that's not a valid choice."
        puts "(please enter 1, 2, 3, or 4)"
        check_population
        #binding.pry
        ################################NOT WORKING###################################
      end
      #binding.pry
    end
    #binding.pry
    #puts all_cities
  end


  def self.turn_city_off(city)
    city.power_switch = "off"
    @@turned_off << city
  end

  def self.check_affordability
    #based on US home price avg, anything below $188,900 is considered affordable
    @@all.each do |city|
      home_price = Scraper.grab_home_prices(Scraper.create_datausa_url(city.name))
      home_price.gsub(/[$,]/, '').to_i < 188900 ? city.avg_home_price = home_price : turn_city_off(city)
    end
  end

  def self.check_diversity
    #us average of white people is 63%
    @@all.each do |city|
      total_population = city.population.tr(',', '').to_i### total population
      white_population = Scraper.grab_diversity(Scraper.create_datausa_url(city.name)).tr(',', '').to_i
      unless city.power_switch == "off"
        diversity_percent = diversity_percentage(total_population, white_population)
        diversity_percent > 37 ? city.diversity_percent = diversity_percent : turn_city_off(city)
      end
    end
  end

    def self.diversity_percentage(total_population, white_population)
      percent = (white_population * 100) / total_population
      percent = 100 - percent
      percent
    end

    def check_safety
      #safety rating under 2000 is safe
      Scraper.grab_safety.each do |city1, safety_index|
        @@all.each do |city|
          if city[0] == city1 && safety_index.tr(',', '').to_i > 2000
            all_cities.delete(city[0])
          else
            if city[0] == city1
              all_cities[city[0]][:crime_index] = safety_index
            end
          end
        end
      end
    end

    def self.create_display_hash
      display_hash = Hash.new do |hash, key|
        hash[key] = {}
      end
      @@all.each do |city|
        if city.power_switch == "on"
          main_key = "#{city.name}, #{city.state_short}"
          city.instance_variables.each do |var|
            unless var.to_s.delete("@") == "state_short" || var.to_s.delete("@") == "state_long" || var.to_s.delete("@") == "name" || var.to_s.delete("@") == "power_switch"
              sub_key = var.to_s.delete("@")
              display_hash[main_key][sub_key] = city.instance_variable_get(var)
            end
          end
        end
      end
      display_hash
    end

##############ADD NIL CONDITION (NO CITIES MEET THE CRITERIA)


end

class City

  attr_accessor :name, :avg_home_price, :diversity_percent, :population, :crime_index, :school_score, :power_switch, :state_short, :state_long, :bio

  STATE_HASH = {  "Alabama" => "AL",
                  "Alaska" => "AK",
                  "Arizona" => "AZ",
                  "California" => "CA",
                  "Colorado" => "CO",
                  "Connecticut" => "CT",
                  "Delaware" => "DE",
                  "Florida" => "FL",
                  "Georgia" => "GA",
                  "Hawaii" => "HI",
                  "Idaho" => "ID",
                  "Illinois" => "IL",
                  "Indiana" => "IN",
                  "Iowa" => "IA",
                  "Kansas" => "KS",
                  "Kentucky" => "KY",
                  "Louisiana" => "LA",
                  "Maine" => "ME",
                  "Maryland" => "MD",
                  "Massachusetts" => "MA",
                  "Michigan" => "MI",
                  "Minnesota" => "MN",
                  "Mississippi" => "MS",
                  "Missouri" => "MO",
                  "Montana" => "MT",
                  "Nebraska" => "NE",
                  "Nevada" => "NV",
                  "New Hampshire" => "NH",
                  "New Jersey" => "NJ",
                  "New Mexico" => "NM",
                  "New York" => "NY",
                  "North Carolina" => "NC",
                  "North Dakota" => "ND",
                  "Ohio" => "OH",
                  "Oklahoma" => "OK",
                  "Oregon" => "OR",
                  "Pennsylvania" => "PA",
                  "Rhode Island" => "RI",
                  "South Carolina" => "SC",
                  "South Dakota" => "SD",
                  "Tennessee" => "TN",
                  "Texas" => "TX",
                  "Utah" => "UT",
                  "Vermont" => "VT",
                  "Virginia" => "VA",
                  "Washington" => "WA",
                  "West Virginia" => "WV",
                  "Wisconsin" => "WI",
                  "Wyoming" => "WY"
                }

  @@all = []

  @@turned_off = []

  def self.all
    @@all
  end

  def self.on_count
    count = 0
    @@all.each do |city|
      count += 1 if city.power_switch == "on"
    end
    count
  end

  def self.reset_last
    @@turned_off.each { |city| city.power_switch = "on" }
  end

  def self.destroy_turned_off
    @@turned_off.clear
  end

  def self.generate_state_short(state_name)
    short_name = STATE_HASH(state_name)
    short_name
  end

  def self.create_city(city, cities_hash)
    city_obj = self.new
    city_obj.name = city[0]
    city_obj.population = cities_hash[city[0]][:population]
    city_obj.state_long = cities_hash[city[0]][:state_name]
    city_obj.state_short = STATE_HASH[cities_hash[city[0]][:state_name]]
    city_obj.power_switch = "on"
    @@all << city_obj
  end




  def self.check_population
    input = gets.strip
    cities_hash = {}
    cities_hash = Scraper.grab_cities
    ##############LOOK INTO SEND METHOD#########################
    cities_hash.each do |city|
      population_count = cities_hash[city[0]][:population].tr(',', '').to_i
      if input == "1"
        create_city(city, cities_hash) if population_count > 150000
      elsif input == "2"
        create_city(city, cities_hash) if population_count > 49999 && population_count < 150000
      elsif input == "3"
        create_city(city, cities_hash) if population_count > 9999 && population_count < 50000
      elsif input == "4"
        create_city(city, cities_hash) if population_count > 1999 && population_count < 10000
      elsif input == "5"
        create_city(city, cities_hash) if population_count < 2000
      else
        puts "Looks like that's not a valid choice."
        puts "(please enter 1, 2, 3, 4 or 5)"
        check_population
        ##################NOT WORKING###############################
      end
    end
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
      white_population = Scraper.grab_diversity(Scraper.create_datausa_url(city.name, city.state_short)).tr(',', '').to_i
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
              all_cities[city[0]][:crime_index] = safety_index if city[0] == city1
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

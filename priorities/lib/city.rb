require 'pry'
require 'colorize'

class City

  attr_accessor :name, :avg_home_price, :diversity_percent, :population, :crime_index, :school_score, :power_switch, :state_short, :state_long, :bio

  STATE_HASH = {  "Alabama" => "AL",
                  "Alaska" => "AK",
                  "Arizona" => "AZ",
                  "Arkansas" => "AR",
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

  @@regions = [ ["West", "WA, OR, CA, NV"],
                ["Northern Rockies", "MT, ID, WY, ND, SD, NE"],
                ["Southern Rockies", "UT, CO, NM, AZ"],
                ["South Central", "TX, OK, KS, MO, AR, LA"],
                ["North Central", "MN, IA, WI, IL, IN, MI, OH"],
                ["Northeast", "ME, NH, VT, MA, RI, NY, CT, PA, NJ, DE, MD"],
                ["Southeast", "MS, AL, GA, GL, SC, NC, TN, KY, VA, WV"]
                ]
  @@all = []

  @@turned_off = []

  def self.all
    @@all
  end



  def self.regions(input) #return the states for the region the user has picked
    region_array = []
    if input == "Northern Rockies"
      region_array = ["Montana", "Idaho", "Wyoming", "North Dakota", "South Dakota", "Nebraska"]
    elsif input == "Southern Rockies"
      region_array = ["Utah", "Colorado", "New Mexico", "Arizona"]
    elsif input == "South Central"
      region_array = ["Texas", "Oklahoma", "Kansas", "Missouri", "Arkansas", "Louisiana"]
    elsif input == "Southeast"
      region_array = ["Mississippi", "Alabama", "Georgia", "Florida", "South Carolina", "North Carolina", "Tennessee", "Kentucky", "Virginia", "West Virginia"]
    elsif input == "North Central"
      region_array = ["Minnesota", "Iowa", "Wisconsin", "Illinois", "Indiana", "Michigan", "Ohio"]
    elsif input == "Northeast"
      region_array = ["Maine", "New Hampshire", "Vermont", "Massachusetts", "Rhode Island", "New York", "Connecticut", "Pennsylvania", "New Jersey", "Delaware", "Maryland"]
    elsif input == "West"
      region_array = ["Washington", "California", "Oregon", "Nevada"]
    else
      #
    end
    region_array
  end

  def self.on_count #grab count of all cities with power_switch turned "on"
    count = 0
    @@all.each do |city|
      count += 1 if city.power_switch == "on"
    end
    count
  end

  def self.reset_last #turn city's that were just turned "off,"" back to "on"
    @@turned_off.each { |city| city.power_switch = "on" }
  end

  def self.destroy_turned_off #destroy memory of turned "off" cities
    @@turned_off.clear
  end

  def self.generate_state_short(state_name)
    short_name = STATE_HASH(state_name)
    short_name
  end

  def self.create_city(city, cities_hash) #initializing attr_accessors first grab of cities
    city_obj = self.new
    city_obj.name = city[0]
    city_obj.population = cities_hash[city[0]][:population]
    city_obj.state_long = cities_hash[city[0]][:state_name]
    city_obj.state_short = STATE_HASH[cities_hash[city[0]][:state_name]]
    city_obj.power_switch = "on"
    @@all << city_obj
  end


  def self.pick_region #ask the user to pick a region
    3.times { fake_delay }
    puts "And which region of the US do you want to start your search in?".green
    @@regions.each_with_index { |region, index| puts "#{index + 1}. #{region[0]} (#{region[1]})".blue }
    input = gets.strip.to_i
    input = input - 1
    input = @@regions[input][0]
    5.times { fake_delay }
    Scraper.generate_state_urls(input)
  end

  def self.check_population #ask the user to pick a population, and then narrow down the results
    input = numbered_input_validator(5)
    cities_hash = {}
    cities_hash = Scraper.grab_cities(pick_region)#grab urls to iterate through based on user's "region" pick
    cities_hash.each do |city| #iterate through the grab_cities hash to generate initial data based on the user's Region pick and population choice
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
        #invalid choice catch
        puts "Looks like that's not a valid choice."
        puts "(please enter 1, 2, 3, 4 or 5)"
        check_population
        ##################NOT WORKING###############################
      end
    end
  end

  def self.turn_city_off(city) #Switch a city's power_switch to "off" if they don't meet the criteria of the user's priority pick
    city.power_switch = "off"
    #Log that this city was turned off, just in case we need to reverse the action
    @@turned_off << city
  end

  def self.check_affordability
    #based on US home price avg, anything below $188,900 is considered affordable
    @@all.each do |city|
      home_price = Scraper.grab_home_prices(Scraper.create_datausa_url(city.name, city.state_short))
      home_price.gsub(/[$,]/, '').to_i < 188900 ? city.avg_home_price = home_price : turn_city_off(city)
    end
  end

  def self.check_diversity
    3.times { fake_delay }
    puts "I'm pulling cities where the percentage of non-White residents is higher than the national average of 47%"
    2.times { fake_delay }
    puts "searching..."
    puts "searching..."
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
      #generate what the user sees after their search is narrowed down to 5 cities or less
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

    def self.numbered_input_validator(num_options)#returns valid numbered input
      input = gets.strip
      valid_options = (1..num_options).to_a
      if valid_options.include?(input.to_i)
        valid_input = input
      else
        puts "That's not a valid number.  Please enter a number between #{valid_options[0]} and #{valid_options[num_options - 1]}."
        numbered_input_validator(num_options)
      end
      valid_input
    end

    def self.yes_no_input_validator
      input = gets.strip
      if input.downcase == "y" || input.downcase == "yes"
        valid_input == "yes"
      else
        valid_input == "no"
      end
        valid_input
    end

    def self.fake_delay
      puts "............."
      sleep(0.5)
    end




end

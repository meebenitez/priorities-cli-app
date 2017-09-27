require 'pry'
require 'colorize'

class City

  attr_accessor :name, :avg_home_price, :diversity_percent, :median_income, :population, :crime_index, :college_grad_percent, :power_switch, :state_short, :state_long, :bio

  @@all = []

  @@turned_off = []

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


  POPULATION_CHOICES = {"Big City" => {greater_than: 149999, less_than: 10000000, description: "pop. 150K+", wait_message: "With a population greater than 150,000 residents..."},
                          "Medium Big City" => {greater_than: 99999, less_than: 150000, description: "pop. 100K to 150K", wait_message: "With a population between 100,000 and 150,000 residents..."},
                          "Medium City" => {greater_than: 49999, less_than: 100000, description: "pop. 50K to 100K", wait_message: "With a population between 50,000 and 100,000 residents..."},
                          "Medium Small City" => {greater_than: 24999, less_than: 50000, description: "pop. 25K to 50K", wait_message: "With a population between 25,000 and 50,000 residents..."},
                          "Small City" => {greater_than: 9999, less_than: 25000, description: "pop. 10K to 25K", wait_message: "With a population between 10,000 and 25,000 residents..."},
                          "Small Town" => {greater_than: 999, less_than: 10000, description: "pop. 1K to 10K", wait_message: "With a population between 1,000 and 10,000 residents..."},
                          "Tiny" => {greater_than: 0, less_than: 1000, description: "pop. < 1K", wait_message: "With a population less than 1,000 residents..."}
                          }


####################CREATE INITIAL LIST OF CITIES#############################
  def self.pick_state
    puts "First, tell me which state would you like to focus your search in?".green
    input = state_input_validator
    Scraper.create_state_urls(input)
  end


  def self.pick_population
    puts "Now tell me what size city you want to live in...".green
    puts " "
    POPULATION_CHOICES.each_with_index { |choice, index| puts "#{index +1}. #{choice[0]} (#{POPULATION_CHOICES[choice[0]][:description]})".blue }
    input = numbered_input_validator(POPULATION_CHOICES.length)
    input = input.to_i - 1
    input = POPULATION_CHOICES.keys[input]
  #  binding.pry
    input
  end


  def self.check_population(state) #ask the user to pick a population, and then narrow down the results
    input = self.pick_population
    cities_hash = {}
    cities_hash = Scraper.grab_cities(state)#grab urls to iterate through based on user's "region" pick
    population_search_message(input, state)
    cities_hash.each do |city| #iterate through the grab_cities hash to generate initial data based on the user's Region pick and population choice
      population_count = cities_hash[city[0]][:population].tr(',', '').to_i
      if input == "Big City"
        create_city(city, cities_hash) if population_count > POPULATION_CHOICES["Big City"][:greater_than]
      elsif input == "Medium Big City"
        create_city(city, cities_hash) if population_count > POPULATION_CHOICES["Medium Big City"][:greater_than] && population_count < POPULATION_CHOICES["Medium Big City"][:less_than]
      elsif input == "Medium City"
        create_city(city, cities_hash) if population_count > POPULATION_CHOICES["Medium City"][:greater_than] && population_count < POPULATION_CHOICES["Medium City"][:less_than]
      elsif input == "Medium Small City"
        create_city(city, cities_hash) if population_count > POPULATION_CHOICES["Medium Small City"][:greater_than] && population_count < POPULATION_CHOICES["Medium Small City"][:less_than]
      elsif input == "Small City"
        create_city(city, cities_hash) if population_count > POPULATION_CHOICES["Small City"][:greater_than] && population_count < POPULATION_CHOICES["Small City"][:less_than]
      elsif input == "Small Town"
        create_city(city, cities_hash) if population_count > POPULATION_CHOICES["Small Town"][:greater_than] && population_count < POPULATION_CHOICES["Small Town"][:less_than]
      else
        create_city(city, cities_hash) if population_count < POPULATION_CHOICES["Tiny"][:less_than]
      end
    end
    POPULATION_CHOICES.delete(input)
    #binding.pry
  end

  def self.create_city(city, cities_hash) #initializing attr_accessors first grab of cities
    city_obj = self.new
    city_obj.name = city[0].sub(" village", '')
    city_obj.population = cities_hash[city[0]][:population]
    city_obj.state_long = cities_hash[city[0]][:state_name]
    city_obj.state_short = STATE_HASH[cities_hash[city[0]][:state_name]]
    city_obj.power_switch = "on"
    @@all << city_obj
    #binding.pry
  end

  def self.population_search_message(input, state)
    POPULATION_CHOICES.each do |choice, index|
      if input == choice
        3.times { fake_delay }
        puts "Finding cities in #{state.keys[0]}..."
        3.times { fake_delay }
        puts POPULATION_CHOICES[choice][:wait_message]
        3.times { fake_delay }
      end
    end
  end



############PRIORITY CHECKS##############################################

#-------------HOME AFFODABILITY-----------------------
  def self.check_affordability
    user_budget = input_price_validator.to_i + 1 #grab the user's budget
    3.times {fake_delay}
    puts "Finding cities where the average home price fits your budget..."
    3.times {fake_delay}
    @@all.each do |city|
      unless city.power_switch == "off"
        home_price = Scraper.grab_home_prices(Scraper.create_datausa_url(city.name, city.state_short))
        if home_price
          home_price.gsub(/[$,mM]/, '').to_i < user_budget ? city.avg_home_price = home_price : turn_city_off(city)
        end
      end
    end

  end

#-------------MEDIAN INCOME----------------------
def self.check_median_income
  @@all.each do |city|
    unless city.power_switch == "off"
      median_income = Scraper.grab_median_income(Scraper.create_city_data_url(city.name, city.state_long))
      unless median_income == nil
        median_income.gsub(/[$,mM]/, '').to_i < 55775 ? city.median_income = median_income : turn_city_off(city)
      end
    end
  end

end

#-------------DIVERSITY-----------------------
  def self.check_diversity
    @@all.each do |city|
      total_population = city.population.tr(',', '').to_i### total population
      unless city.power_switch == "off"
        white_population = Scraper.grab_diversity(Scraper.create_datausa_url(city.name, city.state_short)).tr(',', '').to_i
        diversity_percent = diversity_percentage(total_population, white_population)
        #us
        diversity_percent > 37 ? city.diversity_percent = diversity_percent : turn_city_off(city)
      end
    end
  end

  def self.diversity_percentage(total_population, white_population) #gets percentage of non-white residents
    percent = (white_population * 100) / total_population
    percent = 100 - percent
    percent
  end
#--------------EDUCATION---------------------
def self.check_education #gets cities where the population of college grads is greater than the us avg of 21%
  @@all.each do |city|
    rating = Scraper.grab_education(Scraper.create_city_data_url(city.name, city.state_long)).tr('%', '').to_i
    unless city.power_switch == "off"
      rating > 21 ? city.college_grad_percent = rating : turn_city_off(city)
    end
  end
end

#---------------SAFETY----------------------

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

#########################HELPERS#############################

def self.all
  @@all
end


def self.on_count #grab count of all cities with power_switch turned "on"
  count = 0
  @@all.each do |city|
    count += 1 if city.power_switch == "on"
  end
  count
end

def self.turn_city_off(city) #Switch a city's power_switch to "off" if they don't meet the criteria of the user's priority pick
  city.power_switch = "off"
  #Log that this city was turned off, just in case we need to reverse the action
  @@turned_off << city
end

def self.reset_last #turn city's that were just turned "off," back to "on"
  @@turned_off.each { |city| city.power_switch = "on" }
end

def self.destroy_turned_off #destroy memory of turned "off" cities
  @@turned_off.clear
end

def self.create_state_short(state_name)
  short_name = STATE_HASH(state_name)
  short_name
end

  def self.create_display_hash #generate hash that's pushed to CLI display results
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

  def self.fake_delay
    puts "............."
    sleep(0.5)
  end

#--------------------------INPUT VALIDATORS---------------------------

def self.state_input_validator
  puts "(Please type in the FULL NAME of a state.)".green
  input = gets.strip
  input = input.split(' ').map {|w| w.capitalize }.join(' ')
  STATE_HASH.has_key?(input) ? state = input : state_input_validator
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
  end

  def self.yes_no_input_validator
    puts "enter 'yes' or 'no'"
    input = gets.strip
    if input.downcase == "y" || input.downcase == "yes"
      valid_input = "yes"
    else
      valid_input = "no"
    end
  end

  def self.input_price_validator
    puts "Please enter your home budget:"
    input = gets.strip
    #example "$46,990".gsub(/[\D]/, "")
    input = input.gsub(/[\D]/, "")
    puts "You entered $#{comma_numbers(input)}. Is this correct?"
    yes_no_input_validator == "yes" ? input : input_price_validator
  end

  def self.comma_numbers(number, delimiter = ',')#Helps format price
  number.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{delimiter}").reverse
end


##########################REGION CODE############################

#def self.pick_region #ask the user to pick a region
#  puts "And which region of the US do you want to start your search in?".green
#  @@regions.each_with_index { |region, index| puts "#{index + 1}. #{region[0]} (#{region[1]})".blue }
#  input = numbered_input_validator(@@regions.count)
#  input = input.to_i - 1
#  input = @@regions[input][0]
#  puts "Searching for cities in the #{input} region of the United States..."
#  Scraper.create_state_urls(input)
#end


#@@regions = [ ["Northwest", "WA, OR, ID"],
#              ["West", "CA, NV"],
#              ["Northern Rockies and Plains", "MT, WY, ND, SD, NE"],
#              ["Southwest", "UT, CO, NM, AZ"],
#              ["South", "TX, OK, KS, MS, AR, LA"],
#              ["Upper Midwest", "MN, IA, WI, MI"],
#              ["Central", "MO, IL, IN, OH, KY, TN, WV"],
#              ["Northeast", "ME, NH, VT, MA, RI, NY, CT, PA, NJ, DE, MD"],
#              ["Southeast", "AL, GA, FL, SC, NC, VA"]
#              ]

#def self.regions(input) #return the states for the region the user has picked
#  region_array = []
#  if input == "Northern Rockies and Plains"
#    region_array = ["Montana", "Wyoming", "North Dakota", "South Dakota", "Nebraska"]
#  elsif input == "Southwest"
#    region_array = ["Utah", "Colorado", "New Mexico", "Arizona"]
#  elsif input == "South"
#    region_array = ["Texas", "Oklahoma", "Kansas", "Mississippi", "Arkansas", "Louisiana"]
#  elsif input == "Southeast"
#    region_array = ["Alabama", "Georgia", "Florida", "South Carolina", "North Carolina", "Virginia"]
#  elsif input == "Upper Midwest"
#    region_array = ["Minnesota", "Iowa", "Wisconsin", "Michigan"]
#  elsif input == "Central"
#    region_array = ["Missouri", "Illinois", "Indiana", "Ohio", "Kentucky", "Tennessee", "West Virginia"]
#  elsif input == "Northeast"
#    region_array = ["Maine", "New Hampshire", "Vermont", "Massachusetts", "Rhode Island", "New York", "Connecticut", "Pennsylvania", "New Jersey", "Delaware", "Maryland"]
#  elsif input == "Northwest"
#    region_array = ["Washington", "Oregon", "Idaho"]
#  else
#    region_array = ["California", "Nevada"]
#  end
#  region_array
#end

#################################################################



end

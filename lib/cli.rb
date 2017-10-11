require 'pry'
require 'colorize'

class Priorities::CLI

attr_accessor :last_priority, :priorities

PRIORITIES = ["Home Affordability", "Median Income", "Safety Stats", "% College Grads", "Racial Diversity", "Political Compatibility"]

@@priority_pick_order = []

@@counter = 0

  def call

    puts <<-DOC

                (
                   )
                (            ./\.
             |^^^^^^^^^|   ./LLLL\.
             |`.'`.`'`'| ./LLLLLLLL\.
             |.'`'.'`.'|/LLLL/^^\LLLL\.
             |.`.''``./LLLL/^ () ^\LLLL\.
             |.'`.`./LLLL/^  =   = ^\LLLL\.
             |.`../LLLL/^  _.----._  ^\LLLL\.
             |'./LLLL/^ =.' ______ `.  ^\LLLL\.
             |/LLLL/^   /|--.----.--|\ = ^\LLLL\.
           ./LLLL/^  = |=|__|____|__|=|    ^\LLLL\.
         ./LLLL/^=     |*|~~|~~~~|~~|*|   =  ^\LLLL\.
        ./LLLL/^       |=|--|----|--|=|        ^\LLLL\.
      ./LLLL/^      =  `-|__|____|__|-' =        ^\LLLL\.
    ./LLLL/^   =         `------------'        =    ^\LLLL\.
      ||     =      =      = ____     =         =     ||
      ||  =               .-'    '-.        =         ||
      ||     _..._ =    .'  .-()-.  '.  =   _..._  =  ||
      || = .'_____`.   /___:______:___\   .'_____`.   ||
      || .-|---.---|-.   ||  _  _  ||   .-|---.---|-. ||
      || |=|   |   |=|   || | || | ||   |=|   |   |=| ||
      || |=|___|___|=|=  || | || | ||=  |=|___|___|=| ||
      || |=|~~~|~~~|=|   || | || | ||   |=|~~~|~~~|=| ||
      || |*|   |   |*|   || | || | ||  =|*|   |   |*| ||
      || |=|---|---|=| = || | || | ||   |=|---|---|=| ||
      || |=|   |   |=|   || | || | ||   |=|   |   |=| ||
      || `-|___|___|-'   ||o|_||_| ||   `-|___|___|-' ||
      ||  '---------`  = ||  _  _  || =  `---------'  ||
      || =   =           || | || | ||      =     =    ||
      ||  %@&   &@  =    || |_||_| ||  =   @&@   %@ = ||
      || %@&@% @%@&@    _||________||_   &@%&@ %&@&@  ||
      ||,,\\V//\\V//, _|___|------|___|_ ,\\V//\\V//,,||
      |--------------|____/--------\____|--------------|
      /- _  -  _   - _ -  _ - - _ - _ _ - _  _-  - _ - _ \.
     /_jgs________________________________________________\.
    DOC

    puts <<-DOC.gsub /^\s*/,''
    WELCOME TO THE PRIORITIES GEM!

    I'm here to make your home search a little bit easier by helping you a find a great city to live in based on your PRIORITIES.

    I'll be asking you simple questions, and with the answers you give me, I'll comb through hundreds of cities to come up with a small list that you might just find to be perfect.
      
    Let's get started...
    DOC
        state_hash = City.pick_state
        City.check_population(state_hash)
        results_check(state_hash)

  end


#######################PRIORITY LOGIC##############################

  def pick_priority(state)
    if PRIORITIES.count > 1
    puts "(Enter a number between 1 and #{PRIORITIES.count})".green
    PRIORITIES.each_with_index { |priority, index| puts "#{index + 1}. #{priority}" }
    input = City.numbered_input_validator(PRIORITIES.count).to_i
    input = input - 1
    priority = PRIORITIES[input]
    run_priority_check(priority)
    PRIORITIES.delete(priority)
    @@priority_pick_order << priority
    results_check(state)
    else
      puts "Looks like we've run out of priorities to choose from before we could get our list down to 5.  I guess that means you have lots of cities to look into.  Hurray for options!  Here's your list of cities.  Happy house hunting!"
      display_results_short(City.create_display_hash)
    end
  end

  def run_priority_check(priority)
    if priority == "Home Affordability"
      City.check_affordability
    elsif priority == "Median Income"
      3.times { City.fake_delay }
      puts "Finding cities where the Median Income is higher than the US avg of $55,775."
      2.times { City.fake_delay }
      City.check_median_income
    elsif priority == "% College Grads"
      3.times { City.fake_delay }
      puts "Finding cities where the percentage of college grads among residents is higher than the US avg of 21%"
      2.times { City.fake_delay }
      City.check_education
    elsif priority == "Safety Stats"
      3.times { City.fake_delay }
      puts "Finding cities where the total crimes per 100k people is less than the US average of 2,860"
      2.times { City.fake_delay }
      City.check_crime_stats
    elsif priority == "Racial Diversity"
      3.times { City.fake_delay }
      puts "Finding cities where the percentage of non-White residents is higher than the national average of 37%"
      2.times { City.fake_delay }
      City.check_diversity
    else
      City.check_majority_voters
    end
  end

  def priorities_reset
    PRIORITIES.reset!
  end

#########################RESULTS AND OUTPUT#################################

  def results_check(state)
    City.on_count > 1 ? city_text = "cities" : city_text = "city"
    if City.on_count > 5
         City.destroy_turned_off
      if @@counter < 1
        puts "Alright! I've gathered a list of #{City.on_count} #{city_text} for us to start with. Now, let's start picking priorities!"
        puts "Below is a list of things that a home buyer might consider when choosing a city to move to."
        puts "Give it a quick read, and then pick the priority that would be MOST important to you.".green
        @@counter += 1
        pick_priority(state)
      else
        puts "I found #{City.on_count} #{city_text} that match that criteria.  Let's pick another priority!".green
        pick_priority(state)
      end
    elsif City.on_count == 0
      if @@counter < 1
        puts "Wow.  Looks like we couldn't find any cities that size in #{state.keys[0]}.  Let's try again."
        City.check_population(state)
        results_check(state)
      else
        puts "Looks like none of the cities in your current list fit that criteria."
        puts "Let's choose a different priority."
        City.reset_last
        pick_priority(state)
      end
    else
      if @@counter < 1
        puts "LOL, well that was too easy.  We only found #{City.on_count} #{city_text}."
        display_results_short
        puts " "
        puts "HAPPY HOUSE HUNTING!".green
      else
        puts "Congratulations!  Based on the answers you gave me, I've found #{City.on_count} #{city_text} that might be excellent for you!".blue
        display_results_short
        puts " "
        puts "HAPPY HOUSE HUNTING!".green
      end
    end
  end


  def display_results_short
    City.all.each do |city|
      if city.power_switch == "on"
        puts "#{city.name}".red
        puts "Population: #{city.population}".magenta if city.population
        puts "Avg. Home Price: #{city.avg_home_price}".magenta if city.avg_home_price
        puts "Avg. Median Income: #{city.median_income}".magenta if city.median_income
        puts "Crimes per 100K people: #{city.crimes_per_100k}".magenta if city.crimes_per_100k
        puts "% of College Graduates: #{city.college_grad_percent}".magenta if city.college_grad_percent
        puts "% Racial Diversity: #{city.diversity_percent}".magenta if city.diversity_percent
        puts "Majority Voting Party: #{city.majority_vote}".magenta if city.majority_vote
      end
    end
  end
end

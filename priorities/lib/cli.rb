require 'pry'
require 'colorize'

#Our CLI Controller
class Priorities::CLI

attr_accessor :last_priority, :priorities

@@priorities = ["Weather", "School Quality", "Home Affordability", "Job Market Health", "Safety", "Racial Diversity", "Political Climate"]
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

puts <<-DOC
WELCOME TO THE PRIORITIES GEM!

I'm here to make your home search a little bit easier by helping you a find a great city to live in based on your PRIORITIES.

I'll be asking you simple questions, and with the answers you give me, I'll comb through THOUSANDS of cities to come up with a small list that you might just find to be perfect.

Let's get started...
First things first, I'll be looking at EVERY CITY in the lower 48 states.
DOC
puts "To help me narrow down that search, please tell me what size city you want to live in...".green
puts " "
puts "1. Big City ( pop. 150K+ )".blue
puts "2. Medium City ( pop. 50K to 150K )".blue
puts "3. Small City (pop. 10K to 50K)".blue
puts "4. Small Town (pop. 2K to 10 K)".blue
puts "5. Really Small Town (< pop. 2K)".blue
puts "(please enter 1, 2, 3, 4, or 5)".green


    City.check_population
    results_check

  end


  def pick_priority #puts "Please choose a priority (type 1 - #{@priorities.count})"
    if @@priorities.count > 1
    @@priorities.each_with_index { |priority, index| puts "#{index + 1}. #{priority}" }
    input = gets.strip.to_i
    input = input - 1
    priority = @@priorities[input]
    run_priority_check(priority)
    @@priorities.delete(priority)
    @@priority_pick_order << priority
    results_check
    else
      puts "Looks like we've run out of priorities to choose from before we could get our list down to 5.  I guess that means you have lots of cities to look into.  Hurray for options!  Here's your list of cities.  Happy house hunting!"
      display_results_short(City.create_display_hash)
    end
  end

  def run_priority_check(priority) #["Weather", "School Quality", "Home Affordability", "Job Market Health", "Safety", "Racial Diversity", "Political Climate"]
    if priority == "Weather"
      City.check_weather
    elsif priority == "Home Affordability"
      City.check_affordability
    elsif priority == "Job Market Health"
      puts nil
    elsif priority == "School Quality"
      City.check_schools
    elsif priority == "Safety"
      City.check_safety
    elsif priority == "Racial Diversity"
      City.check_diversity
    elsif priority == "Political Climate"
      puts nil
    else
      puts nil
    end
  end

  def priorities_reset
    @@priorities.reset!
  end

#  def priority_descriptions(priority, extra = nil) #["Weather", "School Quality", "Home Affordability", "Job Market Health", "Safety", "Racial Diversity", "Political Climate"]
#      if priority == "Weather"
#        4.times { City.fake_delay }
#        puts "Finding #{extra} cities for you"
#        4.times { City.fake_delay }
#      elsif priority == "School Quality"
#        4.times { City.fake_delay }
#        puts "Finding Schools "


#  end



  def display_results_short(cities_hash)
    cities_hash.each do |city, attribute|
      puts city.red
      attribute.each do |key, value|
          puts "#{key}: #{value}".magenta
      end
    end
  end

  def results_check
    if City.on_count > 5
      City.destroy_turned_off
      if @@counter < 1
        puts "Alright! I've gathered a list of #{City.on_count} cities for us to start with. Now, let's start picking priorities!"
        puts "Below is a list of things that a home buyer might consider when choosing a city to move to."
        puts "Give it a quick read, and then pick the priority that would be MOST important to you.".green
        @@counter += 1
        pick_priority
      else
        puts "We're at #{City.on_count} cities.  Let's pick another priority!".green
        pick_priority
      end
    elsif City.on_count == 0
      puts "Looks like none of the cities in your current list fit that priority."
      puts "Let's choose a different one."
      City.reset_last
      pick_priority
    else
      puts "Congratulations!  Based on the answers you gave me, I've found #{City.on_count} cities that might be excellent for you!  Here they are:".blue
      display_results_short(City.create_display_hash)
      #need to make a display_results_long
      City.destroy_turned_off
      puts " "
      puts "HAPPY HOUSE HUNTING!".green
    end
  end

end

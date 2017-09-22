require 'pry'

#Our CLI Controller
class Priorities::CLI

attr_accessor :last_priority, :priorities

@@priorities = ["Climate", "School Quality", "Home Affordability", "Employment Rate", "Safety", "Diversity", "Political Mindset"]
@@priority_pick_order = []

  def call

    puts <<-DOC.gsub /^\s*/, ''
    Welcome to the Priorities Gem
    I can help you find the ideal place for you to live based on what's important to you.

    First let's determine what size of a city you want to live in.
    DOC
    puts <<-DOC.gsub /^\s*/, ''
    1. Big City ( 150K+ )
    2. Medium to Big Cities ( 50K+ )
    3. Small Towns (5K to 50K)
    4. Tiny (< 5K)
    (please enter 1, 2, 3, or 4)
    DOC


    #create_cities_hash(Scraper.grab_cities)
    City.check_population
    #City.check_affordability
    #City.check_diversity


    #display_results(City.create_display_hash)

    #pick_priority



  end

  def rewind

  end


  def pick_priority
    #puts "Please choose a priority (type 1 - #{@priorities.count})"
    @@priorities.each_with_index do |priority, index|
      puts "#{index + 1}. #{priority}"
    end

    input = gets.strip.to_i

    input = input - 1

    priority = @@priorities[input]

    @@priorities.delete(priority)

    @@priority_pick_order << priority
    puts "---------#{@@priority_pick_order}"

    pick_priority
  end

  def priorities_reset
    @@priorities.reset!
  end

  def chosen_priorities
  #counter for number system
  #create list hash with num => priority (unless priority == save_last_priority)
  #puts list hash
  end

  def display_populations_results
      puts "You have #{City.all.count} results!  That's much more manageable.  Let's start picking priorities to weed this list down."
  end

  def display_results(cities_hash)
    puts "Here are your results:"
    cities_hash.each do |city, attribute|
      puts "#{city}"
      attribute.each do |key, value|
          puts "#{key}: #{value}"
      end
    end
  end




  def check_schools
    #ratings of 7 and above are considered good
  end

  def count_results
    City.all.count
  end

  def results_check
    if count_results > 30
      puts "You've whittled your list down to #{count_results} cities.  We should probably keep going."
      puts "Pick the next important priority for you..."
      pick_priority
    elsif count_results < 15 && count_results > 5
      puts "You've worked this list down to #{count_results} cities.  Here they are:"
      display_results_short(City.create_display_hash)
      puts "Would you like to keep choosing priorities to get this list even smaller?"
      puts "(enter 'yes' or 'no')"
      input = gets.strip
      if input.downcase = "yes"
        pick_priority
      elsif input.downcase = "no"
        display_results_short(City.create_display_hash)
        #need to make a display_results_long
      else
        puts "invalid response"
      end
    else
      puts "Success!  Here is the list of cities you came up with.  Happy house hunting!"
      display_results_short(City.create_display_hash)
      #need to make a display_results_long
      puts "Would you like to start over?"
    end




end

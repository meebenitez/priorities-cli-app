require 'pry'

#Our CLI Controller
class Priorities::CLI

attr_accessor :last_priority, :priorities

@@priorities = ["Climate", "School Quality", "Home Affordability", "Employment Rate", "Safety", "Diversity", "Political Mindset"]
@@priority_pick_order = []

@@counter = 0

  def call

    puts <<-DOC.gsub /^\s*/, ''
    Welcome to the Priorities Gem
    I can help you find the ideal place for you to live based on what's important to you.

    With the priorities you give me, I'll narrow down a list of 8 or less cities that you might just find perfect.

    First let's determine what size of a city you want to live in.
    DOC
    puts <<-DOC.gsub /^\s*/, ''
    1. Big City ( 150K+ )
    2. Medium City ( 50K to 150K )
    3. Small City (10K to 50K)
    4. Small Town (2K to 10 K)
    5. Tiny (< 2K)
    (please enter 1, 2, 3, 4, or 5)
    DOC


    #create_cities_hash(Scraper.grab_cities)
    City.check_population
    results_check

  end

  def rewind
    #for the future
  end



  def pick_priority
    #puts "Please choose a priority (type 1 - #{@priorities.count})"
    @@priorities.each_with_index { |priority, index| puts "#{index + 1}. #{priority}" }
    input = gets.strip.to_i
    input = input - 1
    priority = @@priorities[input]
    run_priority_check(priority)
    @@priorities.delete(priority)
    @@priority_pick_order << priority
    results_check
  end

  def run_priority_check(priority)
    #["Climate", "School Quality", "Home Affordability", "Employment Rate", "Safety", "Diversity", "Political Mindset"]
    if priority == "Home Affordability"
      City.check_affordability
    elsif priority == "Employment Rate"
      puts nil
    elsif priority == "School Quality"
      City.check_schools
    elsif priority == "Safety"
      City.check_safety
    elsif priority == "Diversity"
      City.check_diversity
    elsif priority == "Political Mindset"
      puts nil
    else
      puts nil
    end
  end

  def priorities_reset
    @@priorities.reset!
  end


  def display_populations_results
      puts "You have #{City.all.count} results!  That's much more manageable.  Let's start picking priorities to weed this list down."
  end

  def display_results_short(cities_hash)
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


  def results_check
    if City.on_count > 15
      City.destroy_turned_off
      puts "You've whittled your list down to #{City.on_count} cities.  But let's try to get you down to 10 or less."
      if @@counter < 1
        puts "Let's pick your first priority"
        @@counter += 1
        pick_priority
      else
        puts "Pick the next important priority for you..."
        pick_priority
      end
    elsif City.on_count < 15 && City.on_count > 8
      City.destroy_turned_off
      puts "You're down to #{City.on_count} cities."
      puts "We're almost there!  I can stop here here and give you more info on these cities.  Or we can keep going."
      puts "(type 1 for STOP HERE)"
      puts "(type 2 for KEEP GOING)"
      input = gets.strip
      if input == "1"
        display_results_short(City.create_display_hash)
      elsif input == "2"
        pick_priority
      else
        puts "invalid entry"
      end
    elsif City.on_count == 0
      puts "Looks like none of the cities in your current list fit that priority."
      puts "Let's choose a different one."
      City.reset_last
      pick_priority
    else
      puts "Success!  Here is the list of cities you came up with.  Happy house hunting!"
      display_results_short(City.create_display_hash)
      #need to make a display_results_long
      City.destroy_turned_off
      puts "Would you like to start over?"
    end
  end




end

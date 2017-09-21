require 'pry'

#Our CLI Controller
class Priorities::CLI

attr_accessor :last_priority, :priorities

@@priorities = ["Climate", "School Quality", "Home Affordability", "Employment Rate", "Safety", "Diversity", "Political Mindset"]
@@priority_pick_order = []

  def call

    puts <<-DOC.gsub /^\s*/, ''
    Welcome to the Priorities Gem
    I can help you find the ideal place for you to live in based on what's important to you.

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
    City.all.each do |city|
      city.instance_variables.each do |var|
        if var.to_s.delete("@") == "name"
          puts city.instance_variable_get(var)
        end
      end
    end

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

  def display_results(priorities_array)
    counter = 1
    all_cities.each do |city|
      puts "#{counter}. #{city.name} - (Pop. #{})"
      counter += 1
    end
  end




  def check_schools
    #ratings of 7 and above are considered good
  end






end

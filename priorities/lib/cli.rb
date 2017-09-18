#Our CLI Controller
class Priorities::CLI

attr_accessor :last_priority, :towns

@@priorities = ["Population Size", "Rural vs Urban environment", "Climate", "School Quality", "Home Affordability", "Employment Rate", "Safety", "Diversity"]

  def call
    puts <<-DOC.gsub /^\s*/, ''
    Welcome to the Priorities Gem
    I can help you find the ideal town for you to live in based on what's important to you.
    Here is a list of priorities that many people consider when choosing a town to live in:

    1. Population Size
    2. Rural vs Urban environment
    3. Climate
    4. School Quality
    5. Home Affordability
    6. Employment Rate
    7. Safety
    8. Diversity


    Please pick the priority that you would consider TOP on your list (most important) when choosing a place to live.
    (Enter 1 thru 8)
    DOC


    #Would you like to start over?
    def save_last_priority(priority)
      @last_priority = priority
      #save the last priority chosen
    end

    def list_priorities
    #counter for number system
    #create list hash with num => priority (unless priority == save_last_priority)
    #puts list hash
    end

    def check_num_input(list_hash)
      #check the value of the number
      #save the value in "last priority chosen"
      #check that the input is valid
    end

    def check_list_size(list_hash)

      #check list_hash count

    end

    def all_towns

    end


    def output_town_details(list_hash)
    end

    def update_bucket
    end




  end

end

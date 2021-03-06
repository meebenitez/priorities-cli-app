# Priorities

Welcome to the Priorities Gem!

Prospective home buyer? Looking to move to a new city? This gem will help you narrow down your city search based on your chosen criteria (budget, politics, safety, education, etc.) in the order you find most important.

'Priorities' sources its data from the following sites:

https://datausa.io  
http://worldpopulationreview.com  
http://www.geostat.org  
http://www.areavibes.com

Check out the video walkthrough here: https://www.youtube.com/watch?v=LiApPW6Xh_I

NOTES:  

IF YOU WANT TO FORK AND TEST THIS GEM, PLEASE USE THE FOLLOWING TEST CASES:  

  1.Type in "Washington" when prompted  
  2.Then select option 4 for a "Medium Small City"

  This will give you a reasonable number of cities to scrape through.  

This gem's reliance on scraping is FOR PROTOTYPE PURPOSES ONLY.  In its current state, checking a priority against 60+ cities can take over a minute because I've included crawl delays between hits to be a more polite web scraper.  Depending on the site being sourced from, some checks take longer than others.  Be prepared to get up and stretch in between searches.  This gem can be easily modified and expanded and is intended to utilize more efficient data sourcing methods.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'priorities'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install priorities

## How it works

Users define the state and population size of the city they want to live in, and city objects are created based on those parameters.  All cities are initialized with a "power_switch" attribute set to "on".

When a user chooses a "priority," a set of conditions is run on all city objects with their power_switch set to "on."  If a city doesn't meet the condition(s), its switch is set to "off."

The user chooses priorities until their list of "on" cities is narrowed down to 5 or less, at which point the cities and their attributes are displayed.

(**note** There is code existing in the bottom comments of each file that will allow you to let the user search by "region" of the US instead of just a state.  This is not set up as default for this prototype as it returns too many results for quick scraping of the given sources.)

## Modifications

This gem is built to be modified.  New priority additions should include the following:

Scraper.rb:  
-"create_url" method  
-"grab" method  
-"input validator" (optional)  

City.rb  
-a new instance variable (attr_accessor)  
-"check" method  

Cli.rb:  
-modification to PRIORITIES  
-modification to the run_priority_check method  
-modification to the "display_results_short" method  


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/'meebenitez-63702'/priorities. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

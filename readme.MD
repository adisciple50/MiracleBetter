

this console script finds the best odds so you always profit. currently bugged with non arb data but usually gets it right. just make sure your odds are outcomes minus 1 if you get your stake back on all outcomes, otherwise your decimal odds should be greater than outcomes. you should always profit if you follow this rule. do not upload backlists without renaming the custom version. a fork is suggested if you want to build your own blacklist for use outside the uk.

# Installation

get an api key starting free at
https://rapidapi.com/api-sports/api/api-football

then store the api key in the environmental variable called API_FOOTBALL_RAPID_API.
(use the export command in your bash.rc or go to environmental variables in windows. use a search engine to research how to set environmental variables for your os if unsure.)


get ruby 3 or later from ruby-lang.org
then with git (get this if not installed - from here https://git-scm.com/download)
git clone https://github.com/adisciple50/MiracleBetter.git

# Usage

to run - type this into your terminal

ruby main.rb

from inside the project directory to run.

also run 

ruby main.rb --tomorrow

to see tommorows odds from tommorows games
from inside the project directory to run.

there are no dependacies so no need for bundler. tested on ruby 3 but it might work on earlier. backports welcome just make a fork.
the author intended riches for all.

caches are stored in todays_odds.json and tommorows_odds.json

if you want to get the latest odds at the cost of api hits (which could cost cents/pennies) then delete todays_odds.json if if you want to refresh todays odds or tomorrows_odds.json if you want to refresh tommorows odds using the --tomorrow switch.

# TODO

* suggest features
* show kickoff time - cant find it atm - use a search engine by pasting the "blah vs blah" search term.
* cleanup data - cannot be arsed cause im too busy winning to bother wrestling with bad data and a non existing data points which would sort this. data does not show posasible outcomes per bet type and instead  this app counts the unique outcomes listed per bet, and then does the math. this script is close enough so do the math.
* auto api betting. now this is where your arbing company employees are made redundant and you can sit on a beach with financial freedome. use a standardised interface pattern or inherit from a common exchange class in order to standardise implentation across a for loop over an array. if you do get a robot to do the hard work, dont forget to share on here. open a branch and ill help. right now i cba.


finds the best odds so you always win. currently bugged with non arb data but usually gets it right. just make sure your odds are outcomes minus 1 if you get your stake back on all outcomes, otherwise your decimal odds should be greater than outcomes. you should allways profit if you follow this rule. do not upload backlists without renaming the custom version. a fork is suggested if you want to build your own blacklist for use outside the uk.


get an api key starting free at
https://rapidapi.com/api-sports/api/api-football

then store the api key in the environmental variable called API_FOOTBALL_RAPID_API.
(use the export command in your bash.rc or go to environmental variables in windows. use a search engine to research how to set environmental variables for your os if unsure.)

installation

git clone 


to run
ruby main.rb

also run 
ruby main.rb --tomorrow
from inside the project directory to run.

there are no dependacies so no need for bundler. tested on ruby 3 but it might work on earlier. backports welcome just make a fork.
the author intended riches for all.

caches are stored in todays_odds.json and tommorows_odds.json

if you want to get the latest odds at the cost of api hits (which could cost cents/pennies) then delete todays_odds.json if if you want to refresh todays odds or tomorrows_odds.json if you want to refresh tommorows odds using the --tomorrow switch.

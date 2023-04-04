require_relative 'football_odds'
require_relative 'game_factory'
require_relative 'chosen_date'
require_relative 'results'
unless ENV["API_FOOTBALL_RAPID_API"]
  raise "API Key not found - please export the environmental variable - API_FOOTBALL_RAPID_API "
end

results = Results.new
results.print_summary
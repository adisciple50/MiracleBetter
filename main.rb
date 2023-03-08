require_relative 'football_odds'
odds = FootballOdds.new
begin
  odds.load_odds_from_file_if_current
rescue
  odds.get_all_odds
  odds.save_all_odds
end

puts odds.to_h["response"][0]
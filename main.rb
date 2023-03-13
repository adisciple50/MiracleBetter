require_relative 'football_odds'
require_relative 'game_factory'
unless ENV["API_FOOTBALL_RAPID_API"]
  raise "API Key not found"
end

odds = FootballOdds.new
begin
  odds.load_odds_from_file_if_current
rescue
  odds.get_all_odds
  odds.save_all_odds
end
games_factory = GameFactory.new(odds.to_h["response"]).then{|gf| gf.create_games}
games_factory.count.times do |i|
  puts games_factory[i].game_name
  puts games_factory[i].winning_each_way_bets
end
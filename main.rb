require_relative 'football_odds'
require_relative 'game_factory'
require_relative 'chosen_date'
unless ENV["API_FOOTBALL_RAPID_API"]
  raise "API Key not found - please export the environmental variable - API_FOOTBALL_RAPID_API "
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
  puts "\n\n"
  puts games_factory[i].game_name
  puts "\n"
  games_factory[i].sort_bets_by_odds_by_type
  games_factory[i].winning_grouped_bets.sort().each do |val|
    val.each do |v|
      v.each do |sub|
        sub.each do |hash|
          puts "==========="
          puts "#{hash[0]}"
          puts "==========="
          last_bet_type = nil
          hash[1].sort_by {|a,b| b }.each do |pair|
            bet_type = pair[0].rpartition("-")[0]
            if last_bet_type.nil?
              last_bet_type = bet_type
            end
            if bet_type == last_bet_type
                last_bet_type = bet_type
              else
                puts "------"
                last_bet_type = bet_type
            end
            puts pair
          end
        end
      end
    end
  end
end
require_relative 'football_odds'
require_relative 'game_factory'
class Results
  def initialize
    odds = FootballOdds.new
    begin
      odds.load_odds_from_file_if_current
    rescue
      odds.get_all_odds
      odds.save_all_odds
    end
    puts odds.to_h
    @games_factory = GameFactory.new(odds.to_h["response"])
    @games_factory.create_games
  end
  def print_full
    @games_factory.count.times do |i|
      puts "\n\n"
      puts @games_factory[i].game_name
      puts "\n"
      @games_factory[i].sort_bets_by_odds_by_type
      @games_factory[i].winning_grouped_bets.sort().each do |val|
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
  end
  def print_summary
    @games_factory.each do |game|
      puts game.game_name
      game.sort_bets_by_odds_by_type
      game.winning_grouped_bets.sort().each do |val|
        val.each do |v|
          v.each do |sub|
            # arr is an array containing the game name and booky on arr[0] and the odds on arr[1]
            sub.each do |arr|
              # per outcome type in this block
              puts "==========="
              puts "#{arr[0]}"
              puts "==========="
              last_bet_type = nil
              bet_types = []
              arr[1].sort_by {|a,b| b }.each do |pair|
                bet_type = pair[0].rpartition("-")[0]
                if last_bet_type.nil?
                  last_bet_type = bet_type
                end
                if bet_type == last_bet_type
                  bet_types[bet_types.count > 0 ? bet_types.count - 1 : 0] << pair
                  last_bet_type = bet_type
                else
                  bet_types << []
                  last_bet_type = bet_type
                end
                bet_types.each do |current_bet_type|
                  puts current_bet_type.max {|a,b| a[1] <=> b[1] }
                end
              end
            end
          end
        end
      end
    end
  end
end
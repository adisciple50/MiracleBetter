require_relative 'lineup'
class Game
  attr_reader :winning_grouped_bets
  attr_reader :game_name
  def initialize(game_hash,fixture)
    @blacklist_file = File.new('blacklist.json','r')
    @blacklist = JSON::parse(@blacklist_file.read)
    @blacklist_file.close
    @winning_grouped_bets = []
    @fixture = fixture[0]
    @game = game_hash
    @bet_ids = get_unique_bet_ids
    @winning_each_way_bets = get_winning_bets
    # puts @game["fixture"]
    # puts @fixture[0]
    begin
      @game_name = "#{@fixture["teams"]["home"]["name"]} vs #{@fixture["teams"]["away"]["name"]}"
    rescue
      @game_name = "unknown"
    end
  end
  def sort_bets_by_odds_by_type
    ids = get_unique_bet_ids
    grouped_bets = []
    ids.each do |id|
      @winning_each_way_bets.each do |bet|
        # puts bet
        unless @blacklist["bookys"].include?(bet[:booky])
          current_bet = bet[:odds].select{|bet| bet["id"] == id}
          # puts "current bet - #{current_bet}"
          unless current_bet.empty?
            if current_bet[0]["id"] == id
              # puts "current bet is - #{current_bet}"
              bets_reduced_to_id = {"#{current_bet[0]["name"]} - #{bet[:booky]}" => current_bet[0] }
              grouped_bets << bets_reduced_to_id
            end
          end
        end
      end
    end
    best_odds_for_bet_id = [{}]
    grouped_bets.each do |bet_group|
      # puts "betgroup is #{bet_group}"
      if bet_group&.values[0]
        bet_group.values[0]["values"].each do |outcome|
          unless best_odds_for_bet_id[0][outcome["value"]]
            best_odds_for_bet_id[0][outcome["value"]] = {bet_group.keys[0] => outcome["odd"].to_f}
          end
          if best_odds_for_bet_id[0][outcome["value"]].values[0] < outcome["odd"].to_f && outcome["odd"].to_f > outcome.count
            best_odds_for_bet_id[0][outcome["value"]].update({"#{bet_group.keys[0]}" => outcome["odd"].to_f})
          end
        end
      end
    end
    if best_odds_for_bet_id
      @winning_grouped_bets << [best_odds_for_bet_id]
    end
  end

  private
  def get_unique_bet_ids
    booky_bet_ids = []
    @game["bookmakers"].each do |booky|
      booky_bet_ids = booky["bets"].map do |bet|
        bet["id"]
      end
    end
    # apply blacklist
    @blacklist["bets"].each do |id|
      booky_bet_ids.delete(id)
    end
    # puts booky_bet_ids.flatten.uniq
    return booky_bet_ids.flatten.uniq
  end
  def get_winning_bets
    @game["bookmakers"].map do |booky|
      {booky: booky["name"],odds: booky["bets"].select(){|bet| bet["values"].any?(){|value| value["odd"].to_f >= bet["values"].count - 1}}}
    end
  end
end
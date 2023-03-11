require_relative 'lineup'
class Game
  attr_reader :winning_each_way_bets
  attr_reader :game_name
  def initialize(game_hash)
    @game = game_hash
    @bet_ids = get_unique_bet_ids
    @winning_each_way_bets = get_winning_bets
    puts @game["fixture"]
    @lineup = Lineup.new(@game["fixture"]["id"])
    @lineup.get
    begin
      @game_name = "#{@lineup.home_team} vs #{@lineup.away_team}"
    rescue
      @game_name = "unknown"
    end
  end
  def sort_bets_by_odds_by_type
    ids = @winning_each_way_bets.map do |booky|
      booky["odds"].each do |bet|
        bet["id"]
      end
    end
    ids.uniq!
    ids.each do |id|
      @winning_each_way_bets.each do |bet|
        bet.select{|odds,v| odds["id"].to_i == id }
      end
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
    return booky_bet_ids.flatten.uniq
  end
  def get_winning_bets
    @game["bookmakers"].map do |booky|
      {booky: booky["name"],odds: booky["bets"].select(){|bet| bet["values"].any?(){|value| value["odd"].to_f >= bet["values"].count - 1}}}
    end
  end
end
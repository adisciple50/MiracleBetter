class Game
  def initialize(game_hash)
    @game = game_hash
    @bet_ids = get_unique_bet_ids
    @winning_each_way_bets = get_winning_bets
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
      over_odds = booky["bets"].select do |bet|
        bet["values"].any? do |value|
          value["odd"].to_f >= bet["values"].count
        end
      end
    #   TODO - collate over odds by bet id
    # TODO - Then for each bet id, make sure that their are less outcomes than collated bets
    # TODO - Then Max the odds for duplicate outcome keys
    end

  end
end
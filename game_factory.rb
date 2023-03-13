require_relative 'game'
require_relative 'fixtures'
class GameFactory
  attr_reader :response
  attr_reader :games
  def initialize(api_response_field)
    @response = api_response_field
    @fixtures = Fixtures.new
  end
  def create_games
    @games = @response.map do |game|
      puts game["fixture"]["id"]
      Game.new(game,@fixtures.get_fixture(game["fixture"]["id"]))
    end
  end
end
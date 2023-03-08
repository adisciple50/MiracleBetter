require_relative 'game'
class GameFactory
  attr_reader :response
  attr_reader :games
  def initialize(api_response_field)
    @response = api_response_field
  end
  def create_games
    @games = @response.map do |game|
      Game.new(game)
    end
  end
end
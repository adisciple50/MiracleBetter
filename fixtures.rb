require 'uri'
require 'net/http'
require 'openssl'
require_relative 'chosen_date'
class Fixtures
  include ChosenDate
  def initialize
    url = URI("https://api-football-v1.p.rapidapi.com/v3/fixtures?date=#{get_date}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = ENV["API_FOOTBALL_RAPID_API"]
    request["X-RapidAPI-Host"] = 'api-football-v1.p.rapidapi.com'

    response = http.request(request)
    @fixtures = JSON::parse response.read_body.to_s
  end
  def get_fixture(fixture_id)
    @fixtures["response"].select{|fixture| fixture["fixture"]["id"] == fixture_id}
  end
end
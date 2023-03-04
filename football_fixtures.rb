require 'uri'
require 'net/http'
require 'openssl'
require 'date'
require 'json'

class FootballFixtures
  def initialize()

    date = Date.today.strftime("%Y-%m-%d")

    url = URI("https://api-football-v1.p.rapidapi.com/v3/fixtures?date=#{date}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = ENV["API_FOOTBALL_RAPID_API_KEY"]
    request["X-RapidAPI-Host"] = 'api-football-v1.p.rapidapi.com'

    @response = http.request(request).read_body
  end

  def to_s
    @response.to_s
  end

  def to_json
    JSON::parse(to_s)
  end

  def to_h
    to_json.to_h
  end
end
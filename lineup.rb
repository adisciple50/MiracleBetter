class Lineup
  def initialize(fixture_id)
    @fixture_id = fixture_id
    @data = ""
  end
  def get
    require 'uri'
    require 'net/http'
    require 'openssl'

    url = URI("https://api-football-v1.p.rapidapi.com/v3/fixtures/lineups?fixture=#{@fixture_id}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = '1705cb0e7bmshf870e4322c873dcp1b2908jsnd47fd32dfd79'
    request["X-RapidAPI-Host"] = 'api-football-v1.p.rapidapi.com'

    response = http.request(request)
    @data = response.read_body
  end
  def to_s
    @data.to_s
  end
  def to_h
    JSON::parse(to_s)
  end
  def home_team
    puts to_h
    to_h["response"][0]["team"]["name"]
  end
  def away_team
    to_h["response"][1]["team"]["name"]
  end
end
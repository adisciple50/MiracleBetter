require 'uri'
require 'net/http'
require 'openssl'
require_relative 'today'
require 'json'
class FootballOdds
  include Today
  attr_reader :page
  attr_reader :all_odds
  attr_reader :current_page_data
  def initialize
    @page = 1
    @url = URI("https://api-football-v1.p.rapidapi.com/v3/odds?date=#{todays_date}&page=#{@page.to_s}")
    get_page
    # it starts with the first page
    @all_odds = {"odds" => []}
    @all_odds_loaded = false
    @todays_odds_filename ='todays_odds.json'
  end

  def to_s
    @current_page_data.to_s
  end

  def to_json
    JSON::parse(to_s)
  end

  def to_h
    to_json.to_h
  end

  def get_page
    http = Net::HTTP.new(@url.host, @url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(@url)
    request["X-RapidAPI-Key"] = ENV["API_FOOTBALL_RAPID_API"]
    request["X-RapidAPI-Host"] = 'api-football-v1.p.rapidapi.com'

    @current_page_data = http.request(request).read_body
  end

  def get_all_odds
    # set results page to first
    first_page
    @all_odds["odds"] += to_h["response"]
    while @page <= total_pages
      next_page
      get_page
      @all_odds["odds"] += to_h["response"]
      sleep 2
    end
  end

  def save_all_odds
    open(@todays_odds_filename,'w') do |f|
      f.write JSON.parse(@all_odds)
    end
  end

  def load_odds_from_file_if_current
    # checks if the file "todays_odds.json" is has been made today...
    todays_odds_file = File.open(@todays_odds_filename,'r')
    unless todays_odds_file.ctime.to_date == todays_date
      @all_odds = JSON.parse(todays_odds_file.read.to_s).to_h
      @all_odds_loaded = true
    else
      # ... complains if it has not.
      raise("The '#{@todays_odds_filename}' file was not created today.")
    end
  end

  def comfirm_odds_as_stale
    @all_odds_loaded = false
  end
  private

  ##
  # please call one of the casting methods (to_s/to_json/to_h) in order to get the current page
  # @example
  # FootballOdds.tap do |odds|
  #   odds.next_page
  #   result = odds.to_h
  # end

  def next_page
    if @page < total_pages
      @page += 1
    else
      @page = 1
    end
  end

  ##
  # please call one of the casting methods (to_s/to_json/to_h) in order to get the current page
  # @example
  # FootballOdds.tap do |odds|
  #   odds.previouse_page
  #   result = odds.to_h
  # end

  def previous_page
    if @page > 1
      @page -= 1
    else
      @page = total_pages
    end
  end

  def total_pages
    to_h["paging"]["total"].to_i
  end
  def get_error
    to_h["errors"]
  end
end
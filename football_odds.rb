require 'uri'
require 'net/http'
require 'openssl'
require_relative 'chosen_date'
require 'json'
class FootballOdds
  include ChosenDate
  attr_reader :page
  attr_reader :all_odds
  attr_reader :current_page_data
  def initialize
    first_page
    @url = URI("https://api-football-v1.p.rapidapi.com/v3/odds?date=#{get_date}&page=#{@page.to_s}")
    get_page
    # it starts with the first page
    @all_odds = {"odds" => []}
    @all_odds_loaded = false
    @todays_odds_filename ='todays_odds.json'
    @tomorrows_odds_filename ='tomorrows_odds.json'
  end

  def to_s
    @current_page_data.to_s
  end

  def to_json
    JSON::generate(to_h)
  end

  def to_h
    JSON::parse(to_s)
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
    @all_odds["odds"] << to_h["response"]
    tp = total_pages
    loop = tp - 1
    minutes, remainder_secs, tp = get_remaining_time
    puts "Downloading Page #{@page} of #{tp} - roughly #{minutes} minutes and #{remainder_secs} seconds remain"
    loop.times do |progress|
      next_page
      get_page
      minutes, remainder_secs, tp = get_remaining_time
      sleep 1
      puts "Downloading Page #{@page} of #{tp} - roughly #{minutes} minutes and #{remainder_secs - 1} seconds remain"
      @all_odds["odds"] << to_h["response"]
      sleep 1
      puts "Downloading Page #{@page} of #{tp} - roughly #{minutes} minutes and #{remainder_secs} seconds remain"
    end
  end

  def save_all_odds
    if Date.today.strftime("%Y-%m-%d") == DATE_TO_USE
      open(@todays_odds_filename,'w') do |f|
        f.write JSON.generate(@all_odds)
      end
    else
      open(@tomorrows_odds_filename,'w') do |f|
        f.write JSON.generate(@all_odds)
      end
    end
  end

  def load_odds_from_file_if_current
    # checks if the file "todays_odds.json" is has been made today...
    if File.exist?(@tomorrows_odds_filename) || File.exist?(@todays_odds_filename)
      todays_odds_file = File.open(@todays_odds_filename,'r')
      todays_odds_file_creation_date = todays_odds_file.ctime.to_date
      tomorrows_odds_file = File.open(@tomorrows_odds_filename,'r')
      tomorrows_odds_file_creation_date = tomorrows_odds_file.ctime.to_date

      if tomorrows_odds_file_creation_date == Date.today && DATE_TO_USE == Date.today.next_day(1).strftime("%Y-%m-%d")
        @all_odds = JSON.parse(tomorrows_odds_file.read.to_s).to_h
        @all_odds_loaded = true
      elsif todays_odds_file_creation_date == Date.today && DATE_TO_USE == Date.today.strftime("%Y-%m-%d")
        @all_odds = JSON.parse(todays_odds_file.read.to_s).to_h
        @all_odds_loaded = true
      else
        # ... complains if it has not.
        raise "The '#{@todays_odds_filename}' file was not created today."
      end
    else
      raise "File Not Found!"
    end
  end

  def comfirm_odds_as_stale
    @all_odds_loaded = false
  end
  private

  def get_remaining_time
    tp = total_pages
    secs = (tp - @page) * 2
    remainder_secs = secs.divmod(60)[1]
    minutes = secs.divmod(60)[0]
    return minutes, remainder_secs, tp
  end

  def first_page
    @page = 1
  end

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
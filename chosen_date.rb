require 'date'
require 'optparse'
require_relative 'chosen_date'
module ChosenDate
  def self.parse_date
    date_to_return = Date.today
    OptionParser.new do |opts|
      opts.on("-t","--tomorrow", "Show And Cache Tomorrows Odds") do |tm|
        date_to_return = Date.today.next_day(1)
      end
    end.parse!
    date_to_return.strftime("%Y-%m-%d")
  end
  DATE_TO_USE = self.parse_date
  def get_date
    DATE_TO_USE
  end
end
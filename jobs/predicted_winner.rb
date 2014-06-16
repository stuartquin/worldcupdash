#!/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'logger'
logger = Logger.new(STDOUT)

# Get a Nokogiri::HTML::Document for the page we’re interested in...

def update logger
  doc = Nokogiri::HTML(open('http://world-cup.betting-directory.com/odds.php'))
  winner = doc.css('.oddsComparisonTable .selection').first
  country = winner.content

  logger.info("Winner #{country}")

  send_event('winner', {text: country,
                        country: country,
                        image: "/" + country + ".png",
                        title: "Predicted Winner"})
end

update(logger)
SCHEDULER.every '15m' do
  update(logger)
end

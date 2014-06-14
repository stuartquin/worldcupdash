#!/bin/ruby
require 'nokogiri'
require 'open-uri'

# Get a Nokogiri::HTML::Document for the page we’re interested in...
doc = Nokogiri::HTML(open('http://world-cup.betting-directory.com/odds.php'))

winner = doc.css('.oddsComparisonTable .selection').first
send_event('winner', { text: winner })

SCHEDULER.every '2s' do
  send_event('winner', {text: winner.content,
                        country: winner.content,
                        image: "/" + winner.content + ".png",
                        title: "Winner"})
end

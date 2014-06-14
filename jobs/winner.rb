#!/bin/ruby
require 'nokogiri'
require 'open-uri'

# Get a Nokogiri::HTML::Document for the page we’re interested in...

def update
  doc = Nokogiri::HTML(open('http://world-cup.betting-directory.com/odds.php'))
  winner = doc.css('.oddsComparisonTable .selection').first
  send_event('winner', {text: winner.content,
                        country: winner.content,
                        image: "/" + winner.content + ".png",
                        title: "Predicted Winner"})
end

SCHEDULER.every '15m' do
  update()
end

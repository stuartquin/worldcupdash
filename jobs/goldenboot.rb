#!/bin/ruby
require 'nokogiri'
require 'open-uri'

# Get a Nokogiri::HTML::Document for the page we’re interested in...
doc = Nokogiri::HTML(open('http://world-cup.betting-directory.com/top-goalscorer-betting.php'))
el = doc.css('#leftColumn > ul > li:nth-child(1)')

country = /\((.*)\)/.match(el.text)[1]

SCHEDULER.every '2s' do
  send_event('goldenboot', {text: el.text,
                            country: country,
                            image: "/" + country + ".png",
                            title: "Top Scorer"})
end

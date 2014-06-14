#!/bin/ruby
require 'nokogiri'
require 'open-uri'

# Get a Nokogiri::HTML::Document for the page we’re interested in...
def update
  doc = Nokogiri::HTML(open('http://world-cup.betting-directory.com/top-goalscorer-betting.php'))
  el = doc.css('#leftColumn > ul > li:nth-child(1)')
  country = /\((.*)\)/.match(el.text)[1]
  send_event('goldenboot', {text: el.text,
                            country: country,
                            image: "/" + country + ".png",
                            title: "Top Scorer"})
end

update()
SCHEDULER.every '15m' do
  update()
end

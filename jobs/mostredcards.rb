#!/bin/ruby
require 'nokogiri'
require 'open-uri'

# Get a Nokogiri::HTML::Document for the page we’re interested in...

def update
  doc = Nokogiri::HTML(open('http://en.m.wikipedia.org/wiki/List_of_FIFA_World_Cup_red_cards'))

  rows = doc.css('.wikitable tr')
  counts = {}

  rows.each do |row|
    country = row.css('td:nth-child(5) a').text.strip
    comp = row.css('td:nth-child(8)').text.strip
    if comp == "2014, Brazil"
      counts[country] = (counts[country] or 0) + 1
    end
  end

  sorted = counts.sort_by {|_key, value| value}
  winner = sorted.last
  country = winner[0]
  text = winner[1].to_s + " - " + country

  send_event('mostreds', {text: text,
                          country: country,
                          image: "/" + country + ".png",
                          title: "Most Reds"})
end

update()
SCHEDULER.every '15m' do
  update()
end

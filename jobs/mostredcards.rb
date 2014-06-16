#!/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'logger'
require './lib/util'
logger = Logger.new(STDOUT)

def update logger
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
  country = Util.get_country country

  logger.info("Most Reds #{country}")

  text = winner[1].to_s + " - " + country

  send_event('mostreds', {text: text,
                          country: country,
                          image: "/" + country + ".png",
                          title: "Most Reds"})
end

update(logger)
SCHEDULER.every '15m' do
  update(logger)
end

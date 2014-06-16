#!/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'logger'
logger = Logger.new(STDOUT)

# Get a Nokogiri::HTML::Document for the page we’re interested in...

def update logger
  doc = Nokogiri::HTML(open('http://en.m.wikipedia.org/wiki/2014_FIFA_World_Cup_statistics'))
  rows = doc.css('ul li')
  country = nil
  time = nil

  rows.each do |row|
    if row.text.strip.start_with?('Fastest goal in a match from kickoff')
      time = row.css("b").text.strip
      country = row.css("a")[1].text.strip
    end
  end
  
  country = 'Argentina'
  logger.info("Fastest Goal #{country}")

  send_event('fastestgoal', {text: time + " (" + country + ")",
                             country: country,
                             image: "/" + country + ".png",
                             title: "Fastest Goal"})
end

update(logger)
SCHEDULER.every '15m' do
  update(logger)
end



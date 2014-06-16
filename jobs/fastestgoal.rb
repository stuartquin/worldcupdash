#!/bin/ruby
require 'nokogiri'
require 'open-uri'

# Get a Nokogiri::HTML::Document for the page we’re interested in...

def update
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

  send_event('fastestgoal', {text: time + " (" + country + ")",
                             country: country,
                             image: "/" + country + ".png",
                             title: "Fastest Goal"})
end

update()
SCHEDULER.every '15m' do
  update()
end



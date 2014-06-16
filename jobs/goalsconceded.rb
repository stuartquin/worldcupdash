#!/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'json'
require 'logger'
logger = Logger.new(STDOUT)

def update logger
  api_key = ENV["KIMONO_KEY"]
  res = open("http://worldcup.kimonolabs.com/api/teams?sort=goalsAgainst,-1&fields=name,goalsAgainst&apikey=#{api_key}")
  data = JSON.parse(res.read).first
  
  country = data["name"]
  logger.info("Goals Conceded #{country}")

  text = data["goalsAgainst"].to_s + " - " + country

  send_event('goalsconceded', {text: text,
                               country: country,
                               image: "/" + country + ".png",
                               title: "Goals Conceded"})
end

update(logger)
SCHEDULER.every '15m' do
  update(logger)
end

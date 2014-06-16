#!/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'json'

def update
  api_key = ENV["KIMONO_KEY"]
  res = open("http://worldcup.kimonolabs.com/api/teams?sort=goalsAgainst,-1&fields=name,goalsAgainst&apikey=#{api_key}")
  data = JSON.parse(res.read).first
  
  country = data["name"]
  text = data["goalsAgainst"].to_s + " - " + country

  send_event('goalsconceded', {text: text,
                               country: country,
                               image: "/" + country + ".png",
                               title: "Goals Conceded"})
end

SCHEDULER.every '15m' do
  update()
end

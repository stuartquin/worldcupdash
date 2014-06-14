#!/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'json'

api_key = ENV["KIMONO_KEY"]

res = open("http://worldcup.kimonolabs.com/api/teams?sort=goalsAgainst,-1&fields=name,goalsAgainst&apikey=#{api_key}")
data = JSON.parse(res.read).first

country = data["name"]
text = data["goalsAgainst"].to_s + " - " + country

SCHEDULER.every '2s' do
  send_event('goalsconceded', {text: text,
                               country: country,
                               image: "/" + country + ".png",
                               title: "Goals Conceded"})
end

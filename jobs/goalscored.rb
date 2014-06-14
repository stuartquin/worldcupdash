#!/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'json'

api_key = ENV["KIMONO_KEY"]

res = open("http://worldcup.kimonolabs.com/api/teams?sort=goalsFor,-1&fields=name,goalsFor&apikey=#{api_key}")
data = JSON.parse(res.read).first

country = data["name"]
text = data["goalsFor"].to_s + " - " + country

SCHEDULER.every '2s' do
  send_event('goalscored', {text: text,
                            country: country,
                            image: "/" + country + ".png",
                            title: "Goals Scored"})
end

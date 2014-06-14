#!/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'json'

def get_current_game games
  live = games.select {|g| g["status"] != "Final"}
  live.first
end


def update
  api_key = ENV["KIMONO_KEY"]
  res = open("http://worldcup.kimonolabs.com/api/matches?sort=startTime&apikey=#{api_key}")
  data = get_current_game JSON.parse(res.read)

  home = "England"
  away = "Italy"

  send_event('livegame', {home_name: home,
                          home_image: "/" + home + ".png",
                          home_score: 0,
                          away_name: away,
                          away_image: "/" + away+ ".png",
                          away_score: 0,})
end
update()
SCHEDULER.every '15m' do
  update()
end

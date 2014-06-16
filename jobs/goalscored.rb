#!/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'json'
require 'logger'
require './lib/util'
logger = Logger.new(STDOUT)


def update logger
  api_key = ENV["KIMONO_KEY"]
  res = open("http://worldcup.kimonolabs.com/api/teams?sort=goalsFor,-1&fields=name,goalsFor&apikey=#{api_key}")
  data = JSON.parse(res.read).first

  country = data["name"]
  country = Util.get_country country
  logger.info("Goals Scored #{country}")

  text = data["goalsFor"].to_s + " - " + country
  send_event('goalscored', {text: text,
                            country: country,
                            image: "/" + country + ".png",
                            title: "Goals Scored"})
end

update(logger)
SCHEDULER.every '15m' do
  update(logger)
end

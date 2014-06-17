#!/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'json'
require 'logger'
require './lib/util'

class GoalsScored
  @@logger = Logger.new(STDOUT)

  def self.update
    api_key = ENV["KIMONO_KEY"]
    res = open("http://worldcup.kimonolabs.com/api/teams?sort=goalsFor,-1&fields=name,goalsFor&apikey=#{api_key}")
    data = JSON.parse(res.read).first
  
    country = data["name"]
    country = Util.get_country country
    @@logger.info("Goals Scored #{country}")
  
    text = data["goalsFor"].to_s + " - " + country
    send_event('goalscored', {text: text,
                              country: country,
                              image: "/" + country + ".png",
                              title: "Goals Scored"})
  end
end

class GoldenBoot
  @@logger = Logger.new(STDOUT)
  def self.update
    doc = Nokogiri::HTML(open('http://world-cup.betting-directory.com/top-goalscorer-betting.php'))
    el = doc.css('#leftColumn > ul > li:nth-child(1)')
    country = /\((.*)\)/.match(el.text)[1]
    country = Util.get_country country
    @@logger.info("Golden Boot #{country}")
    send_event('goldenboot', {text: el.text,
                              country: country,
                              image: "/" + country + ".png",
                              title: "Top Scorer"})
  end
end

class PredictedWinner
  @@logger = Logger.new(STDOUT)
  def self.update
    doc = Nokogiri::HTML(open('http://world-cup.betting-directory.com/odds.php'))
    winner = doc.css('.oddsComparisonTable .selection').first
    country = winner.content

    @@logger.info("Winner #{country}")

    send_event('winner', {text: country,
                          country: country,
                          image: "/" + country + ".png",
                          title: "Predicted Winner"})
  end
end

class MostReds
  @@logger = Logger.new(STDOUT)
  def self.update
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

    @@logger.info("Most Reds #{country}")

    text = winner[1].to_s + " - " + country

    send_event('mostreds', {text: text,
                            country: country,
                            image: "/" + country + ".png",
                            title: "Most Reds"})
  end
end

class GoalsConceded
  @@logger = Logger.new(STDOUT)

  def self.update
    api_key = ENV["KIMONO_KEY"]
    res = open("http://worldcup.kimonolabs.com/api/teams?sort=goalsAgainst,-1&fields=name,goalsAgainst&apikey=#{api_key}")
    data = JSON.parse(res.read).first
    
    country = data["name"]
    country = Util.get_country country
    @@logger.info("Goals Conceded #{country}")
  
    text = data["goalsAgainst"].to_s + " - " + country
  
    send_event('goalsconceded', {text: text,
                                 country: country,
                                 image: "/" + country + ".png",
                                 title: "Goals Conceded"})
  end
end

#!/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'json'
require 'logger'
require './lib/util'

class FastestGoal
  def self.update doc, logger
    rows = doc.css('ul li')
    country = nil
    time = nil

    rows.each do |row|
      if row.text.strip.start_with?('Fastest goal in a match from kickoff')
        time = row.css("b").text.strip
        country = row.css("a")[1].text.strip
      end
    end

    country = Util.get_country country
    logger.info("Fastest Goal #{country}")
    send_event('fastestgoal', {text: time + " (" + country + ")",
                               country: country,
                               image: "/" + country + ".png",
                               title: "Fastest Goal"})
  end
end

class MostReds
  def self.update doc, logger
    rows = doc.css('ul li')
    country = nil
    count = nil

    rows.each do |row|
      if row.text.strip.start_with?('Most red cards (team)')
        count = row.css("b").text.strip
        country = row.css("a")[0].text.strip
      end
    end
    country = Util.get_country country

    logger.info("Most Reds #{country}")
    send_event('mostreds', {text: count + " (" + country + ")",
                            country: country,
                            image: "/" + country + ".png",
                            title: "Most Reds"})
  end
end

# Only hit the wiki page once
class LoadFromWiki
  @@logger = Logger.new(STDOUT)
  def self.update
    doc = Nokogiri::HTML(open('http://en.m.wikipedia.org/wiki/2014_FIFA_World_Cup_statistics'))
    FastestGoal.update doc, @@logger
    MostReds.update doc, @@logger
  end
end


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

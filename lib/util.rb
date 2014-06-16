#!/bin/ruby
class Util
  @@country_map = {
    "United States" => "USA"
  }

  def self.get_country country
    if @@country_map[country]
      return @@country_map[country]
    end
    return country
  end
end

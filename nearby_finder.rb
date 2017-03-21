require "twitter"
require 'linkr'
require 'geokit'
require 'dotenv'

Dotenv.load

class NearbyFinder
  MY_LOCATION = Geokit::LatLng.new(42.3447,-71.0310) # 23 Drydock
  DISTANCE_THRESHHOLD = 2.25 # miles

  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['CONSUMER_KEY']
      config.consumer_secret     = ENV['CONSUMER_SECRET']
      config.access_token        = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    end
  end

  def get_nearby
    tweets = @client.user_timeline("bostonpogomap")
    tweets.select{ |tweet| is_tweet_nearby?(tweet) }
  end

  def is_tweet_nearby?(tweet)
    distance_to_mon(tweet) < DISTANCE_THRESHHOLD
  end

  def distance_to_mon(tweet) #in miles
    encoded_urls = tweet.text.split(" ").last(2)
    real_url = Linkr.resolve(encoded_urls.first)
    mon_location = URI.split(real_url).last
    MY_LOCATION.distance_to(mon_location)
  end
end

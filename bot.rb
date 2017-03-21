require_relative 'nearby_finder'
require 'slack-notifier'

nearby_tweets = NearbyFinder.new.get_nearby

notifier = Slack::Notifier.new(ENV["WEBHOOK_URL"])

nearby_tweets.each{ | nearby_tweet | notifier.ping("nearby: #{nearby_tweet.url.to_s}") }



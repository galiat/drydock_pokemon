require_relative 'nearby_finder'
require 'slack-notifier'

class DryDockBot
  attr_reader :tweet_urls_so_far

  def initialize
    @notifier = Slack::Notifier.new(ENV["WEBHOOK_URL"])
    @tweet_urls_so_far = []
  end

  def run
    while(true)
      find_and_publish_nearby_mons
      sleep 45
    end
  end

  def find_and_publish_nearby_mons
    nearby_tweets = NearbyFinder.new.get_nearby
    nearby_tweet_urls = nearby_tweets.map{ |nearby_tweet| nearby_tweet.url.to_s}

    new_nearby_urls = nearby_tweet_urls - @tweet_urls_so_far
    @tweet_urls_so_far.concat new_nearby_urls

    publish(new_nearby_urls)
  end

  def publish(new_nearby_urls)
    if ENV['QUIET_MODE']
      new_nearby_urls.each{ | nearby | puts("nearby: #{nearby}") }
    else
      new_nearby_urls.each{ | nearby | @notifier.ping("nearby: #{nearby}") }
    end
  end
end

bot = DryDockBot.new
bot.run

bot.tweet_urls_so_far

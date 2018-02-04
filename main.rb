require "twitter"
require "dotenv/load"

class TwitterClient
  def initialize()
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_SECRET"]
      config.access_token        = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end
  end
  
  def show_user_profile(user_id)
    puts "アカウントID: " + @client.user(user_id).screen_name
    puts "アカウント名: " + @client.user(user_id).name
    puts "プロフィール: " + @client.user(user_id).description
  end 
  
  def fav_explosion(user_id)
    @client.user_timeline(user_id).each do |tweet|
      if tweet.full_text.match(/@/) == nil && tweet.full_text.match(/^RT*/) == nil
        puts tweet.full_text
        @client.fav(tweet.id)
      end
    end
  end
end

twitter = TwitterClient.new
print "対象のアカウントIDを入力\n@"
account_id = gets.chomp
twitter.show_user_profile(account_id)
print "対象のユーザーに間違えないですか？(y/n): "
if gets.chomp == "y"
  puts "爆撃開始"
  twitter.fav_explosion(account_id)
end
puts "プログラムを終了します"

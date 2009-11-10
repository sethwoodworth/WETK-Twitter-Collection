# Variations within the saver class:
# - Type of object being saved (tweets, userinfo, followers, followees)
# - Which tag(s) to use 
# - Whether to save, update, or not save 
# 
# Similarities within the saver class: 
# - all recieve an object
# - all receive a rule set

class Saver
  attr_accessor :rules
  
  def initialize(rules={:check_validation => false, :create_relationships => false, :language_detect => false, :tag => nil})
    @rules = rules
  end

  def save(to_save, &save_type)
    save_type.call(to_save, rules)
  end
  
end

TWEET_SAVE = lambda do |tweet_to_save, rules|
  tweet = Tweet.new(:text => tweet_to_save.text, 
                   :time_of_tweet => tweet_to_save.created_at,
                   :to_user_id => tweet_to_save.to_user_id,
                   :iso_language_code => tweet_to_save.iso_language_code,
                   :source => tweet_to_save.source,
                   :profile_image_url => tweet_to_save.profile_image_url,
                   :from_user_id_search => tweet_to_save.from_user_id_search,     
                   :to_user => tweet_to_save.to_user,
                   :from_user  => tweet_to_save.from_user,
                   :status_id  => tweet_to_save.status_id
                    )
  tweet.save
  #If not in DB
  #Active record save
  #According to rules 
  #save associations

end
TWITTER_ACCOUNT_SAVE = lambda do |twitter_account_to_save, rules|
  twitter_account = TwitterAccount.new(:twitter_id => twitter_account_to_save.id,
                        :name => twitter_account_to_save.name, 
                        :screen_name => twitter_account_to_save.screen_name, 
                        :description => twitter_account_to_save.description, 
                        :location => twitter_account_to_save.location, 
                        :profile_image_url => twitter_account_to_save.profile_image_url, 
                        :url => twitter_account_to_save.url, 
                        :protected => twitter_account_to_save.protected, 
                        :followers_count => twitter_account_to_save.followers_count, 
                        :statuses_count => twitter_account_to_save.statuses_count, 
                        :friends_count => twitter_account_to_save.friends_count, 
                        :profile_background_image_url => twitter_account_to_save.profile_background_image_url, 
                        :profile_background_title => twitter_account_to_save.profile_background_title,
                        :favourites_count => twitter_account_to_save.favourites_count, 
                        :time_zone => twitter_account_to_save.time_zone, 
                        :utc_offset => twitter_account_to_save.utc_offset,
                        :time_of_user_creation => twitter_account_to_save.created_at,
                        :profile_background_color => twitter_account_to_save.profile_background_color,
                        :profile_text_color => twitter_account_to_save.profile_text_color,
                        :profile_link_color => twitter_account_to_save.profile_link_color,
                        :profile_sidebar_fill_color => twitter_account_to_save.profile_sidebar_fill_color,
                        :profile_sidebar_border_color => twitter_account_to_save.profile_sidebar_border_color,
                        :notifications => twitter_account_to_save.notifications,
                        :verified => twitter_account_to_save.verified,
                        :twitter_id_for_search => twitter_account_to_save.twitter_id_for_search 
                        )
                        
  twitter_account.save
end
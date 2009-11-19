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
  
  def initialize(rules = {:check_validation => false, :language_detect => false, :tag => nil})
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

  # rules[:tag] ? tweet.tag_list << rules[:tag] : nil

  tweet.save
  #If not in DB
  #Active record save
  #According to rules 
  #save associations

end

USER_TWEET_SAVE = lambda do |tweet_to_save, rules|
  # debugger
  # nil
  puts "user_tweet_save"
  tweet = Tweet.new(:text => tweet_to_save.text, 
                   :time_of_tweet => tweet_to_save.created_at,
                   :to_user_id => tweet_to_save.in_reply_to_user_id,
                   :source => tweet_to_save.source,
                   :profile_image_url => tweet_to_save.user.profile_image_url,     
                   :to_user => tweet_to_save.in_reply_to_screen_name,
                   :from_user  => tweet_to_save.user.screen_name,
                   :twitter_account_id => tweet_to_save.user.id,
                   :status_id  => tweet_to_save.id,
                   :truncated => tweet_to_save.truncated
                    )

  # rules[:tag] ? tweet.tag_list << rules[:tag] : nil

  tweet.save
  #If not in DB
  #Active record save
  #According to rules 
  #save associations

end
TWITTER_ACCOUNT_SAVE = lambda do |twitter_account_to_save, rules|
  puts "twitter account save"
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
                        # :profile_background_title => twitter_account_to_save.profile_background_title,
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

  # rules[:tag] ? twitter_account.tag_list << rules[:tag] : nil
  twitter_account.save

end
CALL_SAVE = lambda do |call_to_save, rules|
call = Call.new(:query => call_to_save.query,
                :completed_in =>  call_to_save.completed_in,
                :since_id => call_to_save.since_id,
                :max_id => call_to_save.max_id,
                :refresh_url => call_to_save.refresh_url,
                :results_per_page => call_to_save.results_per_page,
                :next_page => call_to_save.next_page,
                :page => call_to_save.page,
                :api => call_to_save.api_id)


  rules[:tag] ? call.tag_list << rules[:tag] : nil
                
  call.save
end

RELATIONSHIP_SAVE = lambda do |users_to_save, rules|
#Assuming hash of two SearchUser objects  
#saves a lot of code
puts "relationship save"

  # users_to_save.each_key do |k|
  #   if k.kind_of?(Hash)
  #     users_to_save[k] = TwitterAccount.convert_from_hash(users_to_save[k])
  #   end
  # end
  follower = users_to_save[:follower]
  friend = users_to_save[:friend]      

  # if follower.user_info.nil?     
  #   # Check to see if user exists in db or create new **Skip the check if the db does an auto check for doubles on create
  #   follower.user_info = TwitterAccount.find_or_create_by_screen_name(follower.screen_name)
  # end
  # 
  # if friend.user_info.nil?     
  #   # Check to see if user exists in db or create new **Skip the check if the db does an auto check for doubles on create
  #   friend.user_info = TwitterAccount.find_or_create_by_screen_name(friend.screen_name)
  # end
  
  #create a new twitter_relationship-handle dup check on individual user save 
  twitter_relationship = TwitterRelationship.new(:follower_id => follower.user_info.id, :friend_id => friend.user_info.id, :current => true)


  # rules[:tag] ? twitter_relationship.tag_list << rules[:tag] : nil
  twitter_relationship.save
  #tag relationship  
  #prepend tag with date?  Always tag by date? 
  #rules[:tag] ? twitter_relationship.tag_list << rules[:tag] : nil


end



REACTION_SAVE = lambda do |reaction_to_save, rules|
  if reaction_to_save.kind_of?(Hash)
    reaction_to_save.each_key do |k|
      if k.kind_of?(Hash)
        if users_to_save[k] == :tweet 
          users_to_save[k] = Tweet.convert_from_hash(users_to_save[k]) 
        else 
          users_to_save[k] = TwitterAccount.convert_from_hash(users_to_save[k])
        end
      end
    end
  end
  
  
  initiator = reaction_to_save[:initiator]
  responder = reaction_to_save[:responder]
  tweet = reaction_to_save[:tweet]
  #if it is a hash, convert to object through table_class method

  # Check for id (OUR ID NOT TWITTER'S) (assume it's in db if it's present)
  if initiator.id 
  else
    # Check to see if user exists in db or create new **Skip the check if the db does an auto check for doubles on create
    initiator = TwitterAccount.find_or_create_by_screen_name(initiator.screen_name)
  end

  if responder.id 
  else
    # Check to see if user exists in db or create new **Skip the check if the db does an auto check for doubles on create
    responder = TwitterAccount.find_or_create_by_screen_name(responder.screen_name)
  end

  if tweet.id 
  else
    # Check to see if user exists in db or create new **Skip the check if the db does an auto check for doubles on create
    tweet = TwitterAccount.find_or_create_by_status_id(tweet.status_id)
  end
  
  #create a new twitter_relationship 
  tweet_reaction = TweetReaction.new(:tweet_id => tweet.id, :initiator_id => initiator.id, :responder_id  => responder.id)

  
  rules[:tag] ? tweet_reaction.tag_list << rules[:tag] : nil
  tweet_reaction.save
end
# 
# TREND_SAVE = lambda do |trend_to_save, rules|
# 
# end
# LANGUAGE_SAVE = lambda do |tweet_language_to_save, rules|
# 
# end
# LIST_SAVE = lambda do |list_to_save, rules|
# 
# end
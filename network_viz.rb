$: << File.expand_path(File.dirname(__FILE__) + "/lib")
require 'rubygems'
require 'active_record'
require 'rubygems'
require 'acts-as-taggable-on'
require 'twitter'
require 'ruby-debug'

ActiveRecord::Base.send :include, ActiveRecord::Acts::TaggableOn
ActiveRecord::Base.send :include, ActiveRecord::Acts::Tagger

setup_file = 'funrun_setup.yml'
setup = YAML::load(File.open(setup_file))

ActiveRecord::Base.establish_connection(YAML::load(File.open(setup_file))['db_connect'])
ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))


require 'wetk_twitter'

def random_followers_set(account_set)
  @follower_set = []
  account_set.each do |a|
    @follower_set << random_followers(a, 1).first
  end
  @follower_set  
end

def twitter_accounts_from_names(name_set)

  @accounts = []
  name_set.each do |name|
    @accounts << TwitterAccount.find_by_screen_name(name)
  end
  debugger
  nil
  @accounts
end

def random_followers(origin_account, size)
  followers = origin_account.followers
  @selected_followers = []
  while @selected_followers.size < size and followers.length != 0
    follower = followers[rand(followers.size)]
    if follower
      unless @selected_followers.include?(follower) or follower.attributes["statuses_count"] < 100 or follower.attributes["followers_count"] < 500 or follower.attributes["followers_count"] > 2000 or follower.attributes["friends_count"] > 2000 or follower.attributes["friends_count"] < 500
        @selected_followers << follower
      end
    end
  end
  @selected_followers
end

def warrior_save(ids_to_save)
#get the friend and follower objects
friend = TwitterAccount.find_by_twitter_id(ids_to_save[:the_friend_id])
follower = TwitterAccount.find_by_twitter_id(ids_to_save[:the_follower_id])

#save the relationship
twitter_relationship = TwitterRelationship.new(:follower_id => follower.id, :friend_id => friend.id, :current => true)
twitter_relationship.tag_list << "social_wargaming_I_relationships"
twitter_relationship.save
end

base = Twitter::Base.new(Twitter::HTTPAuth.new(setup['twitter_auth']['username'], setup['twitter_auth']['password'], 
                                        :user_agent => 'Web_Ecology_Project'))

                             
# wargaming_users = Marshal.load(File.new("wargame_users", "r").read)
# wargaming_user_ids =  wargaming_users.collect do |user| user.attributes["twitter_id"] end
# 
  # wargame_relationships = []
  wargaming_relationships = TwitterRelationship.tagged_with("social_wargaming_I_relationships", {})
  war = wargaming_relationships.map do |wr| 
    [TwitterAccount.find(wr.friend_id).screen_name, TwitterAccount.find(wr.follower_id).screen_name]
  end
  debugger
  nil
  puts war
  # wargaming_relationships.each do |target|
  #  
  #   wargame_relationships << TwitterRelationship.find(:conditions => {:friend_id => target.id, :}) 
  # end
  
  # wargame_relationships.map! do |wargame_relationship| 
  #   puts "Friend id is #{wargame_relationship.friend_id}"
  #   puts "Follower id is #{wargame_relationship.follower_id}"
  #   
  #   if wargame_relationship.follower_id and wargame_relationship.friend_id 
  #     [wargame_relationship.friend_id, wargame_relationship.follower_id] 
  #   end
  # end
  # 
  # puts wargame_relationships


# $Puller = Puller.new(base)
# 
# wargaming_user_ids.each do |user|
#   puts "Pulling for: " + user.to_s
#   friend_ids = $Puller.pull({:user_id => user}, &FRIEND_IDS_PULL)
# 
#   friend_ids.each do |id|
#     if wargaming_user_ids.include? id
#       warrior_save({:the_friend_id => id, :the_follower_id => user })
#     end
#   end
# end



# t = TwitterAccount.find_by_screen_name("rosyblue")
# follower_names = followers.map do |f| f.screen_name end




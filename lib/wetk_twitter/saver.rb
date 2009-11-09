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
                    :from_user  => tweet_to_save.text,
                    :status_id  => tweet_to_save.text
                    )
  tweet.save(tweet_to_save)
  #If not in DB
  #Active record save
  #According to rules 
  #save associations

end
USER_SAVE = lambda do |to_save|
  "saving User #{to_save} with the rules: #{rules}"
  #If not in DB
  #Active record save
  #According to rules
  #Save associations  
end  

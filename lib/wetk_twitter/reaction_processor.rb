class ReactionProcessor 
attr_accessor :rules, :user
  def initialize(user)
    @rules = rules
    @user = user
    fill_in_user_info
  end

  def rt_from(tweet)
    
    
  end

  def reply_from(reply_screen_name, tweet)
    reply_twitter_account = TwitterAccount.find_by_screen_name(reply_screen_name)
    unless reply_twitter_account  
      if rules[:pull_secondary_influence_user_info]
        reply_twitter_account = $PULLER.pull({:user => SearchUser.new(:by_screen_name => reply_screen_name)})
      else
        reply_twitter_account = TwitterAccount.create(:screen_name => reply_screen_name)
      end
    end
    $SAVER.save({:initiator => user.db_user_info, :responder => reply_twitter_account, :tweet => tweet, :type => 'reply'}, &REACTION_SAVE)
  end

  def mention_from

  end

  def mention_to
  end

  def rt_to
  end

  def reply_to
  end

  def tweets_from_tweet_ids(tweet_ids)
    tweets = tweet_ids.map do |tweet_id| Tweet.find(tweet_id) end
  end

  def process_reactions()
    # retweets = {}
    # replies = []
    # mentions = {}

    if rules[:mention_from] or rules[:reply_from] or rules[:rt_from]
      if user.by_id
        tweet_ids = $TWITERATOR.twiterate({}, {:user_id => user.by_id}, &USER_TWEETS_ITER)[:tweets]
      else
        tweet_ids = $TWITERATOR.twiterate({}, {:screen_name => user.by_screen_name}, &USER_TWEETS_ITER)[:tweets]        
      end 
      tweets = tweets_from_tweet_ids(tweet_ids)
      tweets.each do |tweet|
        influentials = parse_tweet_for_influentials(tweet)
        if rules[:mention_from] 
          mention_from(influentials[:mention_screen_names], user, tweet.id)
        end
        if rules[:reply_from] 
          reply_from(influentials[:reply_screen_name], user, tweet)
        end
        if rules[:rt_from]
          rt_from(influentials[:rt_screen_names], user, tweet.id)
        end
      end
    end
  end  


  def parse_tweet_for_influentials(tweet)  
    mention_regex = /[@]\w+/
    reply_regex = /^[@]\w+/
    rt_regex = /(^[Rr][Tt] ?[@]\w+| [Rr][Tt] ?[@]\w+)/  
    t_copy = tweet.text.dup
    reply_screen_name = t_copy.scan(reply_regex)
    reply_screen_name.each do |ru|
      t_copy.slice!(/^#{ru}/)
    end
    rt_screen_names = t_copy.scan(rt_regex)
    rt_screen_names.each do |rtu|
      t_copy.slice!(/^#{rtu}| #{rtu}/)
    end
    mention_screen_names = t_copy.scan(mention_regex)
    sanitize_screen_names(reply_screen_name.first, rt_screen_names, mention_screen_names)

  end 

  def sanitize_screen_names(reply_screen_name, rt_screen_names, mention_screen_names)
      sanitizing_regex = /([rR][tT])? ?@/
      reply_screen_name ? reply_screen_name.slice!(sanitizing_regex) : nil
      rt_screen_names.each do |rtu| 
        rtu.slice!(sanitizing_regex) 
      end
      mention_screen_names.each do |mu| 
        mu.slice!(sanitizing_regex) 
      end
      {:reply_screen_name => reply_screen_name, :rt_screen_names => rt_screen_names, :mention_screen_names => mention_screen_names}
  end
  def fill_in_user_info
    if not user.db_user_info
      user.db_user_info = $PULLER.pull({:user=>user}, &USER_PULL)
    end
  end
end


class Puller
  attr_accessor :base
    
  def initialize(base = nil)
    @base = base
  end
  
  def pull(rules, &pull_type)
    
      @rules = rules.dup
    begin
      pull_type.call(@rules, @base)
    # rescue Twitter::Unauthorized  
    # rescue Twitter::Unavailable
    #   raise Twitter::Unavailable
    # rescue Twitter::NotFound
    #   raise Twitter::NotFound
    # rescue Crack::ParseError
    #   raise Crack::ParseError
    # rescue Errno::ETIMEDOUT
    #   log.error "Puller: pull timed out, retrying in 10"
    #   sleep 10
    #   retry
    # rescue Twitter::InformTwitter
    #   log.error "Puller: Twitter 500 error"
    #   sleep 100
    #   retry
    end
  end

end


SEARCH_PULL = lambda do |rules, base|
  puts "SEARCH PULL"
  
  @search_query = rules.delete(:search_query)
  @results = Twitter::Search.new(@search_query, rules).per_page(100)
  rules[:max_id] ? @results.max(rules.delete(:max_id)) : nil
  @results = @results.fetch
  @results.results.each do |result|
    result.status_id = result.id        
    $SAVER.save(result, &TWEET_SAVE)
  end
  @results
end

USER_PULL = lambda do |rules, base|
  puts "USER PULL"
  @user_id = rules.delete(:user_id)
  @results = base.user(@user_id, rules)  
  $SAVER.save(@results, &TWITTER_ACCOUNT_SAVE)
end

FOLLOWERS_PULL = lambda do |rules, base|
  puts "FOLLOWERS PULL"
  @user = rules.delete(:user)
  if @user.by_id
    rules[:user_id] = @user.by_id
  else
    rules[:screen_name] = @user.by_screen_name
  end
  @results = base.followers(rules)
  @results.users.each do |follower_mash|
      if rules[:collect_users] == true 
        $CRAWLER.append(follower_mash.id, follower_mash) 
      end
      db_user_info = $SAVER.save(follower_mash, &TWITTER_ACCOUNT_SAVE)
      $SAVER.save({:friend => @user, :follower => SearchUser.new(:by_id => follower_mash.id, :by_screen_name => follower_mash.screen_name, :db_user_info => db_user_info)}, &RELATIONSHIP_SAVE)
  end
  @results
end

FOLLOWER_IDS_PULL = lambda do |rules, base|
  puts "FOLLOWER_IDS PULL"
  
  @collect = rules.delete(:collect_users)
  @results = base.follower_ids(rules)
  @collect ? @results.each do |user_id| $CRAWLER.append(user_id) end : nil
  @results
end

FRIENDS_PULL = lambda do |rules, base|
  puts "FRIENDS PULL"
  @user = rules.delete(:user)
  if @user.by_id
    rules[:user_id] = @user.by_id
  else
    rules[:screen_name] = @user.by_screen_name
  end
  @results = base.friends(rules)
  @results.users.each do |follower_mash|
      if rules[:collect_users] == true 
        $CRAWLER.append(follower_mash.id, follower_mash) 
      end
      db_user_info = $SAVER.save(follower_mash, &TWITTER_ACCOUNT_SAVE)
      $SAVER.save({:friend => SearchUser.new(:by_id => follower_mash.id, :by_screen_name => follower_mash.screen_name, :db_user_info => db_user_info), :follower => @user}, &RELATIONSHIP_SAVE)
  end
  @results
end

FRIEND_IDS_PULL = lambda do |rules, base|
  puts "FRIEND_IDS PULL"

  @collect = rules.delete(:collect_users)
  @results = base.friend_ids(rules)
  @collect ? @results.each do |user_id| $CRAWLER.append(user_id) end : nil
  @results
end

USER_TWEETS_PULL = lambda do |rules, base|
  puts "USER TWEETS PULL"
  rules[:count] = 200
  @results = base.user_timeline(rules)
  @results.each do |result|
    $SAVER.save(result, &USER_TWEET_SAVE)
  end
  @results
end

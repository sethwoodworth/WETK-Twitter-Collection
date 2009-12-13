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
    rescue Twitter::Unavailable
      $LOG.error "ERROR: Twitter unavailable, trying in 60"
      sleep 60
      retry
    rescue Twitter::NotFound
      $LOG.error "ERROR: Info target not found, trying to skip"
    # rescue Crack::ParseError
    #   raise Crack::ParseError
    rescue Errno::ETIMEDOUT
      $LOG.error "ERROR: Puller timed out, retrying in 10"
      sleep 10
      retry
    rescue Twitter::InformTwitter
      $LOG.error "ERROR: Twitter internal error, retrying in 30"
      sleep 30
      retry
    end
  end

end


SEARCH_PULL = lambda do |rules, base|
  $LOG.info "SEARCH PULL"
  @search_query = rules.delete(:search_query)
  @results = Twitter::Search.new(@search_query, rules).per_page(100)
  rules[:max_id] ? @results.max(rules.delete(:max_id)) : nil
  @results = @results.fetch
  @results.results.each do |result|
    result.status_id = result.id        
    $SAVER.save(result, &TWEET_SAVE)
  end
  rules[:reactions] ? $REACTION_PROCESSOR.process_reactions(@results) : nil
  @results
end

USER_PULL = lambda do |rules, base|
  $LOG.info "USER PULL FOR " + rules[:user_id].to_s
  @user_id = rules.delete(:user_id)
  @results = base.user(@user_id, rules)  
  $SAVER.save(@results, &TWITTER_ACCOUNT_SAVE)
end

FOLLOWERS_PULL = lambda do |rules, base|
  $LOG.info "FOLLOWERS PULL"
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
  $LOG.info "FOLLOWER IDS PULL"
  @user = rules.delete(:user)
  unless @user.db_user_info
    @user.db_user_info = $PULLER.pull({:user_id => @user.search}, &USER_PULL)
    @user.by_id = @user.db_user_info.twitter_id
  end
  rules[:user_id] = @user.by_id
  $SAVER.rules[:complete_follower_set] = true
  @collect = rules.delete(:collect_users)
  @results = base.follower_ids(rules)
  @results.each do |user_id| 
    if @collect 
      $CRAWLER.append(user_id) 
    end
    db_user_info = $SAVER.save(SearchUser.new(:by_id => user_id), &TWITTER_ACCOUNT_SAVE)
    $SAVER.save({:friend => @user, :follower => SearchUser.new(:by_id => user_id, :db_user_info => db_user_info)}, &RELATIONSHIP_SAVE)
  end
  $SAVER.rules[:complete_follower_set] = false
  
  @results
end

FRIENDS_PULL = lambda do |rules, base|
  $LOG.info "FRIENDS PULL"
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
  $LOG.info "FRIEND IDS PULL"
  @user = rules.delete(:user)
  unless @user.db_user_info
    @user.db_user_info = $PULLER.pull({:user_id => @user.search}, &USER_PULL)
    @user.by_id = @user.db_user_info.twitter_id
  end
  rules[:user_id] = @user.by_id
  $SAVER.rules[:complete_friend_set] = true
  @collect = rules.delete(:collect_users)
  @results = base.friend_ids(rules)
  @results.each do |user_id| 
    if @collect 
      $CRAWLER.append(user_id) 
    end
    db_user_info = $SAVER.save(SearchUser.new(:by_id => user_id), &TWITTER_ACCOUNT_SAVE)
    $SAVER.save({:follower => @user, :friend => SearchUser.new(:by_id => user_id, :db_user_info => db_user_info)}, &RELATIONSHIP_SAVE)
  end
  $SAVER.rules[:complete_friend_set] = false
  
  @results
end

USER_TWEETS_PULL = lambda do |rules, base|
  $LOG.info "USER TWEETS PULL"
  rules[:count] = 200
  @results = base.user_timeline(rules)
  @results.each do |result|
    $SAVER.save(result, &USER_TWEET_SAVE)
  end
  rules[:reactions] ? $REACTION_PROCESSOR.process_reactions(@results) : nil
  @results
end

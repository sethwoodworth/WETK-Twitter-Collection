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
  if rules[:user_id]
    @user_id = rules.delete(:user_id)
  else
    @user_id = rules.delete(:screen_name)
  end
  @results = base.user(@user_id, rules)  
  $SAVER.save(@results, &TWITTER_ACCOUNT_SAVE)
  @results
end

FOLLOWERS_PULL = lambda do |rules, base|
  puts "FOLLOWERS PULL"

  @results = base.followers(rules)
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
  @results = base.friends(rules)
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

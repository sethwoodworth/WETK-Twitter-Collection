class Puller
  attr_accessor :rules, :base
    
    def initialize(base = nil)
      @base = base
    end
    
    def pull(rules, &pull_type)
      # begin
        @rules = rules.dup
        pull_type.call(@rules, @base)
      # rescue Twitter::Unavailable
      #          raise Twitter::Unavailable
      #       rescue Twitter::NotFound
      #          raise Twitter::NotFound
      #       rescue Crack::ParseError
      #          raise Crack::ParseError
      #       rescue Errno::ETIMEDOUT
      #         log.error "Puller: pull timed out, retrying in 10"
      #         sleep 10
      #         retry
      #       rescue Twitter::InformTwitter
      #         log.error "Puller: Twitter 500 error"
      #         sleep 100
      #         retry
      # end
      
      # handle bad json from twitter
    
      # call the saver, pass in results one at a time
      
      # pass the last id back to the iterator?
    end
    
    
end


SEARCH_PULL = lambda do |rules, base|
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
  @user_id = rules.delete(:user_id)
  @results = base.user(@user_id, rules)  
  $SAVER.save(@results, &TWITTER_ACCOUNT_SAVE)
  @results
end

FOLLOWERS_PULL = lambda do |rules, base|
  @results = base.followers(rules)
  @results
end

FOLLOWER_IDS_PULL = lambda do |rules, base|
  @collect = rules.delete(:collect_users)
  @results = base.follower_ids(rules)
  @collect ? @results.each do |user_id| $CRAWLER.append(user_id) end : nil
  @results
end

FRIENDS_PULL = lambda do |rules, base|
  @results = base.friends(rules)
  @results
end

FRIEND_IDS_PULL = lambda do |rules, base|
  @collect = rules.delete(:collect_users)
  @results = base.friend_ids(rules)
  @collect ? @results.each do |user_id| $CRAWLER.append(user_id) end : nil
  @results
end

USER_TWEETS_PULL = lambda do |rules, base|
  rules[:count] = 200
  @results = base.user_timeline(rules)
  @results.each do
    #send user tweet to saver
  end
  @results
end

class Puller
  attr_accessor :rules, :base
    
    def initialize(rules = {:user_id => nil, :search_query => nil}, base = nil)
      @rules = rules
      @base = base
    end
    
    def pull(options = {}, &pull_type)
      # begin
        pull_type.call(@rules, options, @base)
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

SEARCH_PULL = lambda do |rules, options, base|
  @results = Twitter::Search.new(rules[:search_query], options).per_page(100).fetch
  @results.results.each do |result|
    result.status_id = result.id        
    $SAVER.save(result, &TWEET_SAVE)
  end
  @results
end

USER_PULL = lambda do |rules, options, base|
  @results = base.user(rules[:user_id],options)
  $SAVER.save(@results, &TWITTER_ACCOUNT_SAVE)
  @results
end

FOLLOWERS_PULL = lambda do |rules, options, base|
  @results = base.followers(options)
  @results.users.each do
    #send follower info (and user id?) to Saver
  end
  @results
end

FOLLOWER_IDS_PULL = lambda do |rules, options, base|
  @results = base.follower_ids(options)
  @results.each do
    #send follower id (and user id?) to Saver
  end
  @results
end

FRIENDS_PULL = lambda do |rules, options, base|
  @results = base.friends(options)
  @results.users.each do
    #send friend info (and user id?) to Saver
  end
  @results
end

FRIEND_IDS_PULL = lambda do |rules, options, base|
  @results = base.friend_ids(options)
  @results.each do
    #send follower id (and user id?) to Saver
  end
  @results
end

USER_TWEETS_PULL = lambda do |rules, options, base|
  options[:count] = 200
  @results = base.user_timeline(options)
  @results.each do
    #send user tweet to saver
  end
  @results
end

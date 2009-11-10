class Puller
  # attr_accessor :rules, :base
  #  
  #  def initialize(rules = {:search_query => nil}, base = nil)
  #    @rules = rules
  #    @base = base
  #  end
  #  
  #  def pull(options, &pull_type)
  #    begin
  #      pull_type.call(@rules, options, @base)
  #    rescue Twitter::Unavailable
  #       raise Twitter::Unavailable
  #    rescue Twitter::NotFound
  #       raise Twitter::NotFound
  #    rescue Crack::ParseError
  #       raise Crack::ParseError
  #    rescue Errno::ETIMEDOUT
  #      log.error "Puller: pull timed out, retrying in 10"
  #      sleep 10
  #      retry
  #    rescue Twitter::InformTwitter
  #      log.error "Puller: Twitter 500 error"
  #      sleep 100
  #      retry
  #    end
  #    
  #    # handle bad json from twitter
  #  
  #    # call the saver, pass in results one at a time
  #    
  # 
  #    
  #    # pass the last id back to the iterator?
  #  end
  #  
  #  
end

# SEARCH_PULL = lambda do |rules, options, base|
#   @results = Twitter::Search.new(rules[:search_query], options).per_page(100).fetch
#   @results.results.each do |tweet|
#     # $SAVER.save(tweet, &TWEET_SAVE)
#     @results
#   end
# end
# 
# USER_PULL = lambda do |rules, options, base|
#   @results = base.user(options)
# end
# 
# FOLLOWERS_PULL = lambda do |rules, options, base|
#   @results = base.followers(options)
# end
# 
# FOLLOWER_IDS_PULL = lambda do |rules, options, base|
#   @results = base.follower_ids(options)
# end
# 
# FRIENDS_PULL = lambda do |rules, options, base|
#   @results = base.friends(options)
# end
# 
# FRIEND_IDS_PULL = lambda do |rules, options, base|
#   @results = base.friend_ids(options)
# end
# 
# USER_TWEETS_PULL = lambda do |rules, options, base|
#   @results = base.user_timeline(options)
# end

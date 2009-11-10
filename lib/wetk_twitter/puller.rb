# Statuses/friends
# statuses/followers
# statuses/user_timeline
# search
# users/show

class Puller
  :attr_accessor :rules, :base
  
  def initialize(rules = {:search_query => nil, :base_type => nil}, base)
    @rules = rules
    @base = base
  end
  
  def pull(options, &pull_type)
    begin
      pull_type.call(rules, options)
    rescue Twitter::Unavailable
       raise Twitter::Unavailable
    rescue Twitter::NotFound
       raise Twitter::NotFound
    rescue Crack::ParseError
       raise Crack::ParseError
    rescue Errno::ETIMEDOUT
      log.error "Puller: pull timed out, retrying in 10"
      sleep 10
      retry
    rescue Twitter::InformTwitter
      log.error "Puller: Twitter 500 error"
      sleep 100
      retry
    end
    
    # handle bad json from twitter
  
    # call the saver, pass in results one at a time
    

    
    # pass the last id back to the iterator?
  end
  
  
end

SEARCH_PULL lambda do |rules, options|
  results = Twitter::Search.new(rules[:search_query], :user_agent => 'web_ecology_project').max(max_ID).per_page(100).fetch
  results.results.each do |tweet|
    $SAVER.save(tweet, &TWEET_SAVE)
  end
end

BASE_PULL lambda do |rules, options|
  results = base.rules[:base_type](options)
  # call saver...
end



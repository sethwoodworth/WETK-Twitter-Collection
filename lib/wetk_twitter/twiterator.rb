class Twiterator
  def initialize()
  end
  def twiterate(my_rules = {},puller_rules = {}, &type)
    if not my_rules[:count]
      my_rules[:count] = 99999999999999
    end
    count = 0 
    my_rules[:cursor] = nil
    result = type.call(my_rules, puller_rules)
    while result[:result] != my_rules[:cursor] && result[:result] != 0 && count < my_rules[:count] do
      my_rules[:cursor] = result[:result]
      result = type.call(my_rules, puller_rules)
      count += result[:count] 
    end
  end
end

SEARCH_ITER = lambda do |my_rules, puller_rules|
    my_rules[:cursor] ? puller_rules[:max_id] = my_rules[:cursor] : nil
    @results = $PULLER.pull(puller_rules, &SEARCH_PULL)
    my_rules[:collect_users] == true ? @results.results.each do |tweet| $CRAWLER.append(tweet.from_user) end : nil
    {:result => @results.results.last.id, :count => @results.results.length}
end

USER_TWEETS_ITER = lambda do |my_rules, puller_rules|
    my_rules[:cursor] ? puller_rules[:max_id] = my_rules[:cursor] : nil
    @result = $PULLER.pull(puller_rules, &USER_TWEETS_PULL)
    {:result => @result.last.id, :count => @results.length}
end

FOLLOWERS_ITER = lambda do |my_rules, puller_rules|
    my_rules[:cursor] ? puller_rules[:cursor] = my_rules[:cursor] : puller_rules[:cursor] = -1
    begin
    @result = $PULLER.pull(puller_rules, &FOLLOWERS_PULL)
    rescue Twitter::InformTwitter
      retry
    rescue Twitter::Unavailable
      retry
    rescue Twitter::RateLimitExceeded
      sleep 120
    end
    {:result => @results.next_cursor, :count => @results.users.length}
end

FRIENDS_ITER = lambda do |my_rules, puller_rules|
  my_rules[:cursor] ? puller_rules[:cursor] = my_rules[:cursor] : puller_rules[:cursor] = -1
  begin
  @results = $PULLER.pull(puller_rules, &FRIENDS_PULL)
  rescue Twitter::InformTwitter
    retry
  rescue Twitter::Unavailable
    retry
  rescue Twitter::RateLimitExceeded
    sleep 120
  end
  {:result => @results.next_cursor, :count => @results.users.length}
end


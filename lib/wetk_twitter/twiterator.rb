class Twiterator
  def initialize()
  end
  def twiterate(my_rules = {},puller_rules = {}, &type)
    @result_ids = {:tweets => []}
    unless my_rules[:count]
      my_rules[:count] = 99999999999999
    end
    count = 0 
    my_rules[:cursor] = nil
    result = type.call(my_rules, puller_rules, @result_ids)
    while result[:result] != my_rules[:cursor] && result[:result] != 0 && count < my_rules[:count] do
      my_rules[:cursor] = result[:result]
      result = type.call(my_rules, puller_rules, @result_ids)
      count += result[:count] 
    end
    debugger
    nil
    @result_ids
  end
end

SEARCH_ITER = lambda do |my_rules, puller_rules, result_ids|
  $LOG.info "SEARCH ITERATION" 
  my_rules[:cursor] ? puller_rules[:max_id] = my_rules[:cursor] : nil
  @results = $PULLER.pull(puller_rules, &SEARCH_PULL)
  debugger
  nil
  @result[:db_objects].each do |r|
    result_ids[:tweets] << r.id 
  end
  my_rules[:collect_users] == true ? @results[:results].results.each do |tweet| $CRAWLER.append(tweet.from_user) end : nil
  {:result => @results[:results].results.last.id, :count => @results[:results].results.length}
end

USER_TWEETS_ITER = lambda do |my_rules, puller_rules, result_ids|
  $LOG.info "USER TWEETS ITERATION"
  my_rules[:cursor] ? puller_rules[:max_id] = my_rules[:cursor] : nil
  @result = $PULLER.pull(puller_rules, &USER_TWEETS_PULL)
  debugger
  nil
  @result[:db_objects].each do |r|
    result_ids[:tweets] << r.id 
  end
  {:result => @result[:results].last.id, :count => @result[:results].length}
end

FOLLOWERS_ITER = lambda do |my_rules, puller_rules, result_ids|  
    $LOG.info "FOLLOWERS ITERATION"
    my_rules[:cursor] ? puller_rules[:cursor] = my_rules[:cursor] : puller_rules[:cursor] = -1
    if my_rules[:count] == 99999999999999
      $SAVER.rules[:complete_follower_set] = true
    end
    begin
    @result = $PULLER.pull(puller_rules, &FOLLOWERS_PULL)
    rescue Twitter::InformTwitter
      retry
    rescue Twitter::Unavailable
      retry
    rescue Twitter::RateLimitExceeded
      sleep 120
    end
    $SAVER.rules[:complete_follower_set] = false
    {:result => @results[:results].next_cursor, :count => @results[:results].users.length}
end

FRIENDS_ITER = lambda do |my_rules, puller_rules, result_ids|
  $LOG.info "FRIENDS ITERATION"
  my_rules[:cursor] ? puller_rules[:cursor] = my_rules[:cursor] : puller_rules[:cursor] = -1
  if my_rules[:count] == 99999999999999
    $SAVER.rules[:complete_friend_set] = true
  end
  begin
  @results = $PULLER.pull(puller_rules, &FRIENDS_PULL)
  rescue Twitter::InformTwitter
    retry
  rescue Twitter::Unavailable
    retry
  rescue Twitter::RateLimitExceeded
    sleep 120
  end
  $SAVER.rules[:complete_friend_set] = false
  {:result => @results[:results].next_cursor, :count => @results[:results].users.length}
end


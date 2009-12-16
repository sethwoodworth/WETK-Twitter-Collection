class Twiterator
  def initialize()
  end
  def twiterate(my_rules = {},puller_rules = {}, &type)
    @db_ids_created = {:tweets => []}
    unless my_rules[:count]
      my_rules[:count] = 99999999999999
    end
    count = 0 
    my_rules[:cursor] = nil
    iter_hash = type.call(my_rules, puller_rules, @db_ids_created)
    while iter_hash[:cursor] != my_rules[:cursor] && iter_hash[:cursor] != 0 && count < my_rules[:count] do
      my_rules[:cursor] = iter_hash[:cursor]
      iter_hash = type.call(my_rules, puller_rules, @db_ids_created)
      count += iter_hash[:count] 
    end
    @db_ids_created
  end
end

SEARCH_ITER = lambda do |my_rules, puller_rules, db_ids_created|
  $LOG.info "SEARCH ITERATION" 
  my_rules[:cursor] ? puller_rules[:max_id] = my_rules[:cursor] : nil
  @pull_hash = $PULLER.pull(puller_rules, &SEARCH_PULL)
  @pull_hash[:db_objects].each do |r|
    db_ids_created[:tweets] << r.id 
  end
  my_rules[:collect_users] == true ? @pull_hash[:pull_data].results.each do |tweet| $CRAWLER.append(tweet.from_user) end : nil
  {:cursor => @pull_hash[:pull_data].results.last.id, :count => @pull_hash[:pull_data].results.length}
end

USER_TWEETS_ITER = lambda do |my_rules, puller_rules, db_ids_created|
  $LOG.info "USER TWEETS ITERATION"
  my_rules[:cursor] ? puller_rules[:max_id] = my_rules[:cursor] : nil
  @pull_hash = $PULLER.pull(puller_rules, &USER_TWEETS_PULL)
  @pull_hash[:db_objects].each do |r|
    db_ids_created[:tweets] << r.id 
  end
  {:cursor => @pull_hash[:pull_data].last.id, :count => @pull_hash[:pull_data].length}
end

FOLLOWERS_ITER = lambda do |my_rules, puller_rules, db_ids_created|  
    $LOG.info "FOLLOWERS ITERATION"
    my_rules[:cursor] ? puller_rules[:cursor] = my_rules[:cursor] : puller_rules[:cursor] = -1
    if my_rules[:count] == 99999999999999
      $SAVER.rules[:complete_follower_set] = true
    end
    begin
    @pull_hash = $PULLER.pull(puller_rules, &FOLLOWERS_PULL)
    rescue Twitter::InformTwitter
      retry
    rescue Twitter::Unavailable
      retry
    rescue Twitter::RateLimitExceeded
      sleep 120
    end
    $SAVER.rules[:complete_follower_set] = false
    {:cursor => @pull_hash[:pull_data].next_cursor, :count => @pull_hash[:pull_data].users.length}
end

FRIENDS_ITER = lambda do |my_rules, puller_rules, db_ids_created|
  $LOG.info "FRIENDS ITERATION"
  my_rules[:cursor] ? puller_rules[:cursor] = my_rules[:cursor] : puller_rules[:cursor] = -1
  if my_rules[:count] == 99999999999999
    $SAVER.rules[:complete_friend_set] = true
  end
  begin
  @pull_hash = $PULLER.pull(puller_rules, &FRIENDS_PULL)
  rescue Twitter::InformTwitter
    retry
  rescue Twitter::Unavailable
    retry
  rescue Twitter::RateLimitExceeded
    sleep 120
  end
  $SAVER.rules[:complete_friend_set] = false
  {:cursor => @pull_hash[:pull_data].next_cursor, :count => @pull_hash[:pull_data].users.length}
end


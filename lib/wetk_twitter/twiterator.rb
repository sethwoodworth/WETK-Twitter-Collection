class Twiterator
  def initialize()
  end
  def twiterate(my_rules = {},puller_rules = {}, &type)
    
    my_rules[:cursor] = nil
    result = type.call(my_rules, puller_rules)
    while result != my_rules[:cursor] && result != 0 do
      my_rules[:cursor] = result
      result = type.call(my_rules, puller_rules)
    end
  end
end

SEARCH_ITER = lambda do |my_rules, puller_rules|
    my_rules[:cursor] ? puller_rules[:max_id] = my_rules[:cursor] : nil
    @results = $PULLER.pull(puller_rules, &SEARCH_PULL)
    my_rules[:collect_users] == true ? @results.results.each do |tweet| $CRAWLER.append(tweet.from_user) end : nil
    @results.results.last.id
end

USER_TWEETS_ITER = lambda do |my_rules, puller_rules|
    my_rules[:cursor] ? puller_rules[:max_id] = my_rules[:cursor] : nil
    @result = $PULLER.pull(puller_rules, &USER_TWEETS_PULL)
    @result.last.id
end

FOLLOWERS_ITER = lambda do |my_rules, puller_rules|
    my_rules[:cursor] ? puller_rules[:cursor] = my_rules[:cursor] : puller_rules[:cursor] = -1
    @result = $PULLER.pull(puller_rules, &FOLLOWERS_PULL)
    my_rules[:collect_users] == true ? @results.users.each do |user| $CRAWLER.append(user.id, @result) end : nil
    @results.users.each do |follower_mash|
        $SAVER.save(follower_mash, &TWITTER_ACCOUNT_SAVE)
        $SAVER.save({:friend => my_rules[:user_info], :follower => follower_mash}, &RELATIONSHIP_SAVE)
    end
    @results.next_cursor
end

FRIENDS_ITER = lambda do |my_rules, puller_rules|
  my_rules[:cursor] ? puller_rules[:cursor] = my_rules[:cursor] : puller_rules[:cursor] = -1
  @results = $PULLER.pull(puller_rules, &FRIENDS_PULL)
  my_rules[:collect_users] == true ? @results.users.each do |user| $CRAWLER.append(user.id, @result) end : nil
  @results.users.each do |friend_mash|
     $SAVER.save(friend_mash, &TWITTER_ACCOUNT_SAVE)
     $SAVER.save({:follower => my_rules[:user_info], :friend => friend_mash}, &RELATIONSHIP_SAVE)
  end
  @results.next_cursor
end


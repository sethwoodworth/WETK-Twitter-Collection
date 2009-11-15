class Twiterator
  attr_accessor :type
  def initialize(&type)
    @type = type
  end
  def twiterate(my_rules = {},puller_rules = {})
    my_rules[:cursor] = nil
    result = @type.call(my_rules, puller_rules)
    while true do
      if result == my_rules[:cursor] || result == 0
        break
      else
        my_rules[:cursor] = result
      end
      result = @type.call(my_rules, puller_rules)
    end
  end
end

SEARCH_ITER = lambda do |my_rules, puller_rules|
    my_rules[:cursor] ? puller_rules[:max_id] = my_rules[:cursor] : nil
    @results = $PULLER.pull(puller_rules, &SEARCH_PULL)
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
    @results.users.each do |follower_mash|
       # $SAVER.save({:friend => my_rules[:user_info], :follower => follower_mash}, &RELATIONSHIP_SAVE)
    end
    @results.next_cursor
end

FRIENDS_ITER = lambda do |my_rules, puller_rules|
  my_rules[:cursor] ? puller_rules[:cursor] = my_rules[:cursor] : puller_rules[:cursor] = -1
  @results = $PULLER.pull(puller_rules, &FRIENDS_PULL)
  @results.users.each do |friend_mash|
    # $SAVER.save({:follower => my_rules[:user_info], :friend => friend_mash}, &RELATIONSHIP_SAVE)
  end
  @results.next_cursor
end


class Twiterator
  attr_accessor :type
  def initialize(&type)
    @type = type
  end
  def twiterate(my_rules = {},puller_rules = {})
    cursor = nil
    result = @type.call(cursor, puller_rules)
    while true do
      if result == cursor || result == 0
        break
      else
        cursor = result
      end
      result = @type.call(cursor, puller_rules)
    end
  end
end

SEARCH_ITER = lambda do |cursor, puller_rules|
    cursor ? puller_rules[:max_id] = cursor : nil
    @results = $PULLER.pull(puller_rules, &SEARCH_PULL)
    @results.results.last.id
end

USER_TWEETS_ITER = lambda do |cursor, puller_rules|
    cursor ? puller_rules[:max_id] = cursor : nil
    @result = $PULLER.pull(puller_rules, &USER_TWEETS_PULL)
    @result.last.id
end

FOLLOWERS_ITER = lambda do |cursor, puller_rules|
    cursor ? puller_rules[:cursor] = cursor : puller_rules[:cursor] = -1
    @result = $PULLER.pull(puller_rules, &FOLLOWERS_PULL)
    @results.next_cursor
end

FRIENDS_ITER = lambda do |cursor, puller_rules|
  cursor ? puller_rules[:cursor] = cursor : puller_rules[:cursor] = -1
  @results = $PULLER.pull(puller_rules, &FRIENDS_PULL)
  @results.next_cursor
end


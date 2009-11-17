class Crawler
  attr_accessor :users  
  def initialize(users= [], depth, &crawl_type)
    @depth = depth
    @crawl_type = crawl_type
    @users = {}
    users.each do |user|
      @users[user] = 'uncrawled'
    end
  end
  
# crawl type = RT_TO_USER_CRAWL, RT_FROM_USER_CRAWL, 'mention_to_user' 'mention_from_user', 'reply_to_user', 'reply_from_user','followers', 'friends', 
  
  def crawl(depth, &crawl_type)
    while depth > 0
      @users.dup.each do |user_array|
        if user_array[1] == 'uncrawled'
          crawl_type.call(user_array[0])
          @users[user_array[0]] = 'crawled'
        end
      end
      depth -= 1
    end
    @users.keys
  end
  
  def search_crawl(search_query)
    $TWITERATOR.twiterate({:collect_users => true}, {:search_query => search_query}, &SEARCH_ITER)
    @users.keys
  end
  
  def append(user)
    @users[user] ? nil : @users[user] = 'uncrawled'
  end
  
end

FOLLOWER_IDS_CRAWL = lambda do |user|
  $PULLER.pull({:user_id => user, :collect_users => true}, &FOLLOWER_IDS_PULL)
end

FRIEND_IDS_CRAWL = lambda do |user|
  $PULLER.pull({:user_id => user, :collect_users => true}, &FRIEND_IDS_PULL)
end

FOLLOWERS_CRAWL = lambda do |user|
  $TWITERATOR.twiterate({:collect_users => true}, {:user_id => user}, &FOLLOWERS_ITER)
end

FRIENDS_CRAWL = lambda do |user|
  $TWITERATOR.twiterate({:collect_users => true}, {:user_id => user}, &FRIENDS_ITER)
end


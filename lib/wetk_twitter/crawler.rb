require 'ruby-debug'
class Crawler
  attr_accessor :users, :depth, :crawl_type  
  def initialize(users = [], depth = 0, crawl_type = nil)
    @depth = depth
    @crawl_type = crawl_type_str_to_proc(crawl_type)
    @users = {}
    users.each do |user|
      @users[user] = 'uncrawled'
    end
  end
  
  def crawl_type_str_to_proc(str)
    proc_dict = {'followers' => FOLLOWERS_CRAWL}
    proc_dict[str]
  end
# crawl type = RT_TO_USER_CRAWL, RT_FROM_USER_CRAWL, 'mention_to_user' 'mention_from_user', 'reply_to_user', 'reply_from_user','followers', 'friends', 
  
  def crawl(search_query = nil)

    if not @users.empty?
      while @depth > 0
        @users.dup.each do |user_array|
          if user_array[1] == 'uncrawled'
            @crawl_type.call(user_array[0], search_query)
            @users[user_array[0]] = 'crawled'
          end
        end
        @depth -= 1
      end
    else 
      @crawl_type.call(nil,search_query)
    end
    @users.keys
  end
  
  def search_crawl(search_query)  
  end
  
  def append(user)
    @users[user] ? nil : @users[user] = 'uncrawled'
  end
  
end

SEARCH_CRAWL = lambda do |user, search_query|
  $TWITERATOR.twiterate({:collect_users => true}, {:search_query => search_query}, &SEARCH_ITER)
  # @users.keys
  search_query
end

FOLLOWER_IDS_CRAWL = lambda do |user, search_query|
  $PULLER.pull({:user_id => user, :collect_users => true}, &FOLLOWER_IDS_PULL)
end

FRIEND_IDS_CRAWL = lambda do |user, search_query|
  $PULLER.pull({:user_id => user, :collect_users => true}, &FRIEND_IDS_PULL)
end

FOLLOWERS_CRAWL = lambda do |user, search_query|
  $TWITERATOR.twiterate({:collect_users => true}, {:user_id => user}, &FOLLOWERS_ITER)
end

FRIENDS_CRAWL = lambda do |user, search_query|
  $TWITERATOR.twiterate({:collect_users => true}, {:user_id => user}, &FRIENDS_ITER)
end


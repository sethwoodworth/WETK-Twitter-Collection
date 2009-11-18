require 'ruby-debug'
class Crawler
  attr_accessor :users, :depth, :crawl_type  
  def initialize(users = [], depth = 0, crawl_type = nil)
    @depth = depth
    @crawl_type = crawl_type_str_to_proc(crawl_type)
    @users = []
    if users['by_id']
      users['by_id'].each do |id|
        @users << SearchUser.new(:by_id => id, :crawled => false)
      end
    end
    if users['by_screen_name']
      users['by_screen_name'].each do |screen_name|
        @users << SearchUser.new(:by_screen_name => screen_name, :crawled => false)
      end
    end

  end
  
  def crawl_type_str_to_proc(str)
    proc_dict = {'followers' => FOLLOWERS_CRAWL}
    proc_dict[str]
  end
# crawl type = RT_TO_USER_CRAWL, RT_FROM_USER_CRAWL, 'mention_to_user' 'mention_from_user', 'reply_to_user', 'reply_from_user','followers', 'friends', 
  
  def crawl(search_query = nil)
    unless @users.empty?
      while @depth > 0
        @users.dup.each do |user|
          unless user.crawled?
            @crawl_type.call(user.search, search_query)
            @users.each do |u|
              if u.search == user
                u.crawled = true
              end
            end
          end
        end
        @depth -= 1
      end
      else 
        @crawl_type.call(nil,search_query)
      end
      # debugger
      # nil
      @users.collect { |u| u.search }
    end
  
  def search_crawl(search_query)  
  end
  
  def append(user)
    @users.each do |u|
      unless u.search != user
        #HEY SAM IS THIS WHAT WE SHOULD DO?
        if user.class = String
          @users << SearchUser.new(:crawled => false, :by_screen_name => user)          
        else
          @users << SearchUser.new(:crawled => false, :by_id => user)
        end
      end
    end

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
  if user.class == String
    $TWITERATOR.twiterate({:collect_users => true}, {:screen_name => user}, &FOLLOWERS_ITER)
  else
    $TWITERATOR.twiterate({:collect_users => true}, {:user_id => user}, &FOLLOWERS_ITER)    
  end
end

FRIENDS_CRAWL = lambda do |user, search_query|
  $TWITERATOR.twiterate({:collect_users => true}, {:user_id => user}, &FRIENDS_ITER)
end


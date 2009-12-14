require 'ruby-debug'
class Crawler
  attr_accessor :users, :depth, :crawl_type  
  def initialize(users = [], depth = 0, crawl_type = nil, count = nil)
    @depth = depth
    @crawl_type = crawl_type_str_to_proc(crawl_type)
    @users = users
    @count = count

  end
  
  def crawl_type_str_to_proc(str)
    proc_dict = {'followers' => FOLLOWERS_CRAWL, 'friends' => FRIENDS_CRAWL, 'follower_ids' => FOLLOWER_IDS_CRAWL, 'friend_ids' => FRIEND_IDS_CRAWL}
    proc_dict[str]
  end
# crawl type = RT_TO_USER_CRAWL, RT_FROM_USER_CRAWL, 'mention_to_user' 'mention_from_user', 'reply_to_user', 'reply_from_user',
  
  def crawl(search_query = nil)
    unless @users.empty?
      while @depth > 0
        @users.dup.each do |user|
          unless user.crawled?
            @crawl_type.call(user, search_query, @count)
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
      @crawl_type.call(nil,search_query, @count)
    end
    @users  # .collect { |u| u.search }
  end
  
  def search_crawl(search_query)  
  end
  
 
  def append(user, user_info = nil)
    user_search_args = @users.collect do |u|
      u.search
    end
    unless user_search_args.include?(user)
      if user.class == String
        @user = SearchUser.new(:crawled => false, :by_screen_name => user)          
      else
        @user = SearchUser.new(:crawled => false, :by_id => user)
      end
      if user_info
        @user.user_info = user_info 
      end
 
      @users << @user 
    end
  end
end

SEARCH_CRAWL = lambda do |user, search_query, count|
  $LOG.info "SEARCH CRAWL"
  $TWITERATOR.twiterate({:collect_users => true}, {:search_query => search_query}, &SEARCH_ITER)
  # @users.keys
  search_query
end

FOLLOWER_IDS_CRAWL = lambda do |user, search_query, count|
  $LOG.info "FOLLOWER IDS CRAWL"
  $PULLER.pull({:user_id => user, :collect_users => true}, &FOLLOWER_IDS_PULL)
end

FRIEND_IDS_CRAWL = lambda do |user, search_query, count|
  $LOG.info "FRIEND IDS CRAWL"
  $PULLER.pull({:user_id => user, :collect_users => true}, &FRIEND_IDS_PULL)
end

FOLLOWERS_CRAWL = lambda do |user, search_query, count|
  $LOG.info "FOLLOWERS CRAWL"
  if not user.db_user_info
    user.db_user_info = $PULLER.pull({:user => user}, &USER_PULL)
  end
  $TWITERATOR.twiterate({:count => count}, {:collect_users => true, :user => user}, &FOLLOWERS_ITER)    
end

FRIENDS_CRAWL = lambda do |user, search_query, count|
  $LOG.info "FRIENDS CRAWL"
  if not user.db_user_info
    user.db_user_info = $PULLER.pull({:user => user}, &USER_PULL)
  end
  $TWITERATOR.twiterate({ :count => count}, {:collect_users => true, :user => user}, &FRIENDS_ITER)    
end


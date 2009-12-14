require 'ruby-debug'
class Planner
  attr_accessor :options, :user_list
  
  def initialize(base, options)
    @options = options
    @user_list = []
    if options['query']['users']['by_id']
      options['query']['users']['by_id'].each do |id|
        @user_list << SearchUser.new(:by_id => id, :crawled => false)
      end
    end
    if options['query']['users']['by_screen_name']
      options['query']['users']['by_screen_name'].each do |screen_name|
        @user_list << SearchUser.new(:by_screen_name => screen_name, :crawled => false)
      end
    end
    @options["saving_options"]["tags"]["execution_tag"] = Time.now.to_i.to_s
    $SAVER = Saver.new(@options['saving_options'])
    $PULLER = Puller.new(base)
    # debugger
    # nil
    unless @options['crawling_options'] == nil
      $CRAWLER = Crawler.new(@user_list, @options['crawling_options']['depth'], @options['crawling_options']['crawl_type'], @options['crawling_options']['count'])
    end
    $TWITERATOR = Twiterator.new
    setup_logger
    end

  def pull
    if $CRAWLER
      @user_list = $CRAWLER.crawl
    end
    if @user_list.empty? 
      $TWITERATOR.twiterate({}, {:search_query => self.options['query']['search']}, &SEARCH_ITER)
    else
      get_info(@user_list)
    end
  end

  def get_info(users)
    if options['info_to_get']['user_tweets']
      users.each do |user|
        if user.by_screen_name
          $TWITERATOR.twiterate({}, {:screen_name => user.by_screen_name}, &USER_TWEETS_ITER)
        else
          $TWITERATOR.twiterate({}, {:user_id => user.by_id}, &USER_TWEETS_ITER)        
        end
      end
    end
    if options['info_to_get']['user_info'] 
      users.each do |user|
        unless user.user_info
          $PULLER.pull({:user => user}, &USER_PULL)
        end
      end
    end
    if options['info_to_get']['followers'] 
      users.each do |user|
        $TWITERATOR.twiterate({},{:user => user}, &FOLLOWERS_ITER)
      end
    end
    if options['info_to_get']['friends'] 
      users.each do |user|
        $TWITERATOR.twiterate({},{:user => user}, &FRIENDS_ITER)
      end
    end
    if options['info_to_get']['follower_ids'] 
      users.each do |user|
        $PULLER.pull({:user => user}, &FOLLOWER_IDS_PULL)
      end
    end
    if options['info_to_get']['friend_ids'] 
      users.each do |user|
        $PULLER.pull({:user => user}, &FRIEND_IDS_PULL)
      end
    end
    
  end
  
  
  def search_term
    
  end
  def setup_logger
    $LOG = Logger.new(retrieve_log_output)
    $LOG.level = retrieve_log_level
    $LOG.info "logger is working"
  end
  
  def retrieve_log_level
   eval "Logger::#{@options['logger']['level']}"
  end
  
  def retrieve_log_output
    output = @options['logger']['output']
    if output == "STDOUT" 
      eval output
    else
      output
    end
  end
end
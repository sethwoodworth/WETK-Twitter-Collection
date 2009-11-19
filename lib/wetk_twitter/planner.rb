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
    $SAVER = Saver.new(@options['saving_rules'])
    $PULLER = Puller.new(base)
    $CRAWLER = Crawler.new(@user_list, @options['crawling_options']['depth'], @options['crawling_options']['crawl_type'])
    $TWITERATOR = Twiterator.new
  end

  def pull
    @user_list = $CRAWLER.crawl
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
        $PULLER.pull({:user_id => user.search}, &USER_PULL)
      end
    end
  end
  
  
  def search_term
    
  end
  
end
require 'ruby-debug'
class Planner
  attr_accessor :options
  
  def initialize(base, options)
    $SAVER = Saver.new(options['saving_rules'])
    $PULLER = Puller.new(base)
    $CRAWLER = Crawler.new(options['query']['users'], options['crawling_options']['depth'], options['crawling_options']['crawl_type'])
    $TWITERATOR = Twiterator.new
    @options = options
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
        $TWITERATOR.twiterate({}, {:user_id => user}, &USER_TWEETS_ITER)
      end
    end
    if options['info_to_get']['user_info'] && $CRAWLER.crawl_type != FOLLOWERS_CRAWL && $CRAWLER.crawl_type != FRIENDS_CRAWL
      users.each do |user|
        $PULLER.pull({:user_id => user}, &USER_INFO_PULL)
      end
    end
  end
  
  def search_term
    
  end
  
end
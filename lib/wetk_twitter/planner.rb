class Planner
  
  def initialize(base, options)
    $SAVER = Saver.new(options['saving_rules'])
    $PULLER = Puller.new(base)
    $CRAWLER = Crawler.new(options['crawling_options'])
    $TWITERATOR = Twiterator.new
    @options = options
  end

{:search_query => taco, :crawl_type => 'search', :get_info => {:user_tweets => true, :user_info => true}}


  def pull
    @user_list = $CRAWLER.crawl
    if @user_list.empty? 
      $TWITERATOR.twiterate({}, {:search_query => options[:search_query]}, &SEARCH_ITER)
    else
      get_info(@user_list)
    end
  end

  def crawl

  end

  def get_info(users)
    if options[:get_info][:user_tweets]
      users.each do |user|
        $TWITERATOR.twiterate({}, {:user_id => user}, &USER_TWEETS_ITER)
      end
    end
    if option[:get_info][:user_info] && $CRAWLER.crawl_type != FOLLOWERS_CRAWL && $CRAWLER.crawl_type != FRIENDS_CRAWL
      users.each do |user|
        $PULLER.pull({:user_id => user}, &USER_INFO_PULL)
      end
    end
  end
  
  def search_term
    
  end
  
end
class Planner
  attr_accessor :saver, :puller, :crawler
  
  def initialize(base, options)
    @saver = Saver.new(options['saving_rules'])
    @puller = Puller.new(base)
    @crawler = Crawler.new(options['crawling_options'])
  end

  def pull
    @crawler.crawl
  end

  def self.db_connect(db_connect)
    ActiveRecord::Base.establish_connection(YAML::load(File.open(filename))['db_connect'])
    ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))
  end

  def self.authenticate_twitter_user(twitter_auth)
    Twitter::Base.new(Twitter::HTTPAuth.new(twitter_auth['username'], twitter_auth['password'], :user_agent => USER_AGENT))    
  end



end
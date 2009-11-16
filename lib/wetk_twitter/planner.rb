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


end
class Planner
  
  def initialize(base, options)
    $SAVER = Saver.new(options['saving_rules'])
    $PULLER = Puller.new(base)
    $CRAWLER = Crawler.new(options['crawling_options'])
    $TWITERATOR = Twiterator.new
  end

  def pull
    $CRAWLER.crawl
  end

end
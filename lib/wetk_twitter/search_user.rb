require 'ruby-debug'
class SearchUser
  attr_accessor :by_id, :by_screen_name, :crawled
  
  def initialize(opts)
    @by_id = sanitize_id(opts[:by_id])
    @by_screen_name = opts[:by_screen_name]
    @crawled = opts[:crawled]
  end

  def crawled?
    @craweled
  end
    
  def search
    by_id ? by_id : by_screen_name    
  end

  def sanitize_id(id)
    id.nil? ? nil : id.to_i 
  end
  
end
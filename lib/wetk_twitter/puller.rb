class Puller
  :attr_accessor :api, :query
  
  def initialize(api,query)
    @api = api
    @query = query
  end
  
  def pull
    #call the api
    # handle errors from twitter
    # handle bad json from twitter
    # call the saver, pass in results one at a time
    # pass the last id back to the iterator?
  end
  
  
end

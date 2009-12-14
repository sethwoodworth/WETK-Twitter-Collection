class ReactionProcessor 
attr_accessor :rules



def initialize(rules={:mention_from => false, 
                      :mention_to => false, 
                      :reply_from => false, 
                      :reply_to => false,
                      :retweet_from => false,
                      :retweet_to => false})
  @rules = rules
end

def process_reactions(tweets)

  # retweets = {}
  # replies = []
  # mentions = {}
  mention_regex = /[@]\w+/
  reply_regex = /^[@]\w+/
  rt_regex = /(^[Rr][Tt] ?[@]\w+| [Rr][Tt] ?[@]\w+)/
  
  tweets.each do |t|
    t_copy = t.dup
    reply_usernames = t_copy.scan(reply_regex)
    reply_usernames.each do |ru|
      t_copy.slice!(/^#{ru}/)
    end
    rt_usernames = t_copy.scan(rt_regex)
    rt_usernames.each do |rtu|
      t_copy.slice!(/^#{rtu}| #{rtu}/)
    end
    mention_usernames = t_copy.scan(mention_regex)
  end
  
end


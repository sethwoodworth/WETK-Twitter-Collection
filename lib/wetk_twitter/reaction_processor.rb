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
  
  
end


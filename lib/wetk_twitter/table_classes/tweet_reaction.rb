class TweetReaction < ActiveRecord::Base
  belongs_to :tweet
  belongs_to :twitter_account, :foreign_key => :initiator_id
  belongs_to :twitter_account, :foreign_key => :responder_id  
  belongs_to :reaction
end

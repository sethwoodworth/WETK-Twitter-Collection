class TweetReaction < ActiveRecord::Base
  acts_as_taggable_on :tags, :projects
  
  belongs_to :tweet
  belongs_to :initiator, :class_name => "TwitterAccount"
  belongs_to :responder, :class_name => "TwitterAccount"  
  belongs_to :reaction
end

class TwitterRelationship < ActiveRecord::Base
  belongs_to :friend, :class_name => "TwitterAccount"
  belongs_to :follower, :class_name => "TwitterAccount"  
end

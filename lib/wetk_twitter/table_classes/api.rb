class Api < ActiveRecord::Base
  acts_as_taggable_on :tags, :projects  
  has_many :calls
end
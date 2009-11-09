class Confidence < ActiveRecord::Base
  acts_as_taggable_on :tags, :projects
  belongs_to :language
  belongs_to :twitter_account
  belongs_to :tweet
end

class CreateCallsTweets < ActiveRecord::Migration
  def self.up
    create_table :calls_tweets, :id => false do |t|
      t.integer :call_id, :null => false, :dependent => :destroy, :limit => 8
      t.integer :tweet_id, :null => false, :dependent => :destroy, :limit => 8
    end
    # add_index :calls_tweets, :calls_id
    # add_index :calls_tweets, :tweets_id

    #Provisioning write access to table(s)
    execute "GRANT INSERT ON calls_tweets TO db_squirtle;"


  end

  def self.down
    drop_table :calls_tweets
  end
end

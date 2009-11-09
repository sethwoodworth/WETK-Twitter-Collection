class CreateTweetReactions < ActiveRecord::Migration
  def self.up
    create_table :tweet_reactions do |t|
      t.integer :initiator_id, :null => false, :dependent => :destroy, :limit => 8
      t.integer :responder_id, :null => false, :dependent => :destroy, :limit => 8
      t.integer :tweet_id, :null => false, :dependent => :destroy, :limit => 8
      t.references :reaction
      t.boolean :current
      t.timestamps            
    end
    
    # add_index :trends_twitter_accounts, :twitter_accounts_id
    # add_index :trends_twitter_accounts, :trends_id

    #Provisioning write access to table(s)
    execute "GRANT INSERT ON tweet_reactions TO db_squirtle;"
    
  end

  def self.down
    drop_table :tweet_reactions
  end
end

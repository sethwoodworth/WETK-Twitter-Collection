class CreateCallsTrends < ActiveRecord::Migration
  def self.up
    create_table :calls_trends, :id => false  do |t|
      t.integer :call_id, :null => false, :dependent => :destroy, :limit => 8
      t.integer :trend_id, :null => false, :dependent => :destroy, :limit => 8
    end
    # add_index :calls_trends, :calls_id
    # add_index :calls_trends, :trends_id

    #Provisioning write access to table(s)
    execute "GRANT INSERT ON calls_trends TO db_squirtle;"
    
  end

  def self.down
    drop_table :calls_trends
  end
end

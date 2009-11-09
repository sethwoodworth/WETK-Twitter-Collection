class CreateTrends < ActiveRecord::Migration
  def self.up
    #
    create_table :trends do |t|
      t.string :topic
      
      t.timestamps
    end
    change_column :trends, :id, :integer, :limit => 8

    # add_index :trends, :topic
    #Provisioning write access to table(s)
    execute "GRANT INSERT ON trends TO db_squirtle;"

  end

  def self.down
    drop_table :trends
  end
end

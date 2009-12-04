class RemoveScreenNameRequirementForTwitterAccounts < ActiveRecord::Migration
  def self.up
    execute "alter table twitter_accounts " +  
    "alter column screen_name drop not null;"    
  end

  def self.down
    execute "alter table customers " +
    "alter column surname set not null;"
  end

end
  
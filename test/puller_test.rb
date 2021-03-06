require "#{File.dirname(__FILE__)}/test_helper"

class PullerTest < Test::Unit::TestCase
  context "An authenticated default puller" do
    setup do
      $SAVER = Saver.new
      @base = Twitter::Base.new(Twitter::HTTPAuth.new('sam1vp', 'twAg60307', :user_agent => 'web_ecology_project'))
      @p = Puller.new(@base)
      @user_info_keys = ["created_at", "description", "favourites_count", "followers_count", "following", "friends_count", "geo_enabled", "id", "location", "name", "notifications", "profile_background_color", "profile_background_image_url", "profile_background_tile", "profile_image_url", "profile_link_color", "profile_sidebar_border_color", "profile_sidebar_fill_color", "profile_text_color", "protected", "screen_name", "status", "statuses_count", "time_zone", "url", "utc_offset", "verified"]
      db_user_info = TwitterAccount.create({:twitter_id => 15019521,:screen_name => 'sam1vp'})
      @test_user = SearchUser.new(:by_id => 15019521, :db_user_info => db_user_info)
      $LOG = Logger.new(STDOUT)
      $LOG.level = Logger::INFO
    end
  
    should "be able to be created" do
      @p.inspect
    end  
    
    should "be able to pull followers for a given user and cursor" do
      @pull_hash = @p.pull({:user => @test_user, :cursor => -1}, &FOLLOWERS_PULL)
      assert_same_elements @pull_hash[:pull_data].users.first.keys, @user_info_keys
      
    end
    
    should "be able to pull an array of follower ids for a given user_id" do
      @pull_hash = @p.pull({:user => @test_user}, &FOLLOWER_IDS_PULL)
      assert_equal @pull_hash[:pull_data].class, Array
      assert_equal @pull_hash[:pull_data].first.class, Fixnum

    end
      
    should "be able to pull friends for a given user and cursor" do
      @pull_hash = @p.pull({:user => @test_user, :cursor => -1}, &FRIENDS_PULL)
      assert_same_elements @pull_hash[:pull_data].users.first.keys, @user_info_keys
    end
        
    should "be able to pull an array of friend IDs for a given user_id" do
      @pull_hash = @p.pull({:user => @test_user}, &FRIEND_IDS_PULL)
      assert_equal @pull_hash[:pull_data].class, Array
      assert_equal @pull_hash[:pull_data].first.class, Fixnum
    end
    
    should "be able to pull tweets from a user's timeline for a given user_id" do
      @pull_hash = @p.pull({:user_id => 15019521}, &USER_TWEETS_PULL)
      assert_same_elements @pull_hash[:pull_data].first.keys, ["created_at", "truncated", "favorited", "text", "id", "geo", "in_reply_to_user_id", "in_reply_to_screen_name", "source", "user", "in_reply_to_status_id"]
    end
    
  
    should "be able to pull a hash from twitter_search with particular fields" do
      @pull_hash = @p.pull({:search_query => 'test'}, &SEARCH_PULL)
      assert_same_elements @pull_hash[:pull_data].keys, ["results", "max_id", "since_id", "refresh_url", "next_page", "results_per_page", "page", "completed_in", "query"]
    end
    
    should "be able to pull info from twitter for a user" do
      @pull_hash = @p.pull({:user => @test_user}, &USER_PULL)
      assert_equal @pull_hash[:pull_data].screen_name, 'sam1vp'
    end

  end
end
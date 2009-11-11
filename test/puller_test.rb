require "test_helper"

class PullerTest < Test::Unit::TestCase
  context "An authenticated default puller" do
    setup do
      @base = Twitter::Base.new(Twitter::HTTPAuth.new('sam1vp', 'twAg60307', :user_agent => 'web_ecology_project'))
      @p = Puller.new({}, @base)
      @user_info_keys_sorted = ["created_at", "description", "favourites_count", "followers_count", "following", "friends_count", "geo_enabled", "id", "location", "name", "notifications", "profile_background_color", "profile_background_image_url", "profile_background_tile", "profile_image_url", "profile_link_color", "profile_sidebar_border_color", "profile_sidebar_fill_color", "profile_text_color", "protected", "screen_name", "status", "statuses_count", "time_zone", "url", "utc_offset", "verified"]
    end
  
    should "be able to be created" do
      @p.inspect
    end  
    
    should "be able to pull followers from twitter for a given user_id" do
      @results = @p.pull({:user_id => 15019521}, &FOLLOWERS_PULL)
      assert_equal @results.first.keys.sort, @user_info_keys_sorted
      
    end
    
     should "be able to pull an array of user ids from twitter for a given user_id" do
        @results = @p.pull({:user_id => 15019521}, &FOLLOWER_IDS_PULL)
        assert_equal @results.class, Array
        assert_equal @results.first.class, Fixnum

      end
      
       should "be able to pull valid json of friends from twitter for a given user_id" do
          @results = @p.pull({:user_id => 15019521}, &FRIENDS_PULL)
          assert_equal @results.first.keys.sort, @user_info_keys_sorted
        end
        
         should "be able to pull an array of friend IDs from twitter for a given user_id" do
            @results = @p.pull({:user_id => 15019521}, &FRIEND_IDS_PULL)
            assert_equal @results.class, Array
            assert_equal @results.first.class, Fixnum
          end
    
    context "with a :search_query value in its rules attribute" do
      setup do
        @p.rules = {:search_query => 'test'}
      end
    
      should "be able to pull valid json from twitter search" do
        results = @p.pull({}, &SEARCH_PULL)
        assert_equal results.keys, ["results", "max_id", "since_id", "refresh_url", "next_page", "results_per_page", "page", "completed_in", "query"]
      end
    end
  
    context "with a :user_id value in its rules attribute" do 
      setup do 
        @p.rules = {:user_id => 15019521}
      end
    
      should "be able to pull info from twitter for that user" do
        results = @p.pull({}, &USER_PULL)
        assert_equal results.keys.sort, @user_info_keys_sorted
        assert_equal results.screen_name, 'sam1vp'
      end
    end
  end
end
require "test_helper"

class SaverTest < Test::Unit::TestCase
  context "A default saver" do
    setup do
      @saver = Factory.build(:saver)
      
    end
    context "when saving a unique tweet" do
      setup do
        @tweet = Factory.build(:tweet)
        @saver.save(@tweet, &TWEET_SAVE)
      end
      should "allow the tweet to be saved" do
          assert_equal @tweet.text, Tweet.find_by_text(@tweet.text).text
      end
    end
    context "when saving a unique user" do
      setup do
        @twitter_account = Factory.build(:twitter_account)
        @saver.save(@twitter_account, &TWITTER_ACCOUNT_SAVE)        
      end
    
      should "allow the user to be saved" do
        assert_equal @twitter_account.screen_name, TwitterAccount.find_by_screen_name(@twitter_account.screen_name).screen_name
      end
    end
    context "when saving a call" do
      setup do
        @call = Factory.build(:call)
        @saver.save(@call, &CALL_SAVE)        
      end
    
      should "allow the call to be saved" do
        assert_equal @call.query, Call.find_by_query(@call.query).query
      end
    end
    
  end
end
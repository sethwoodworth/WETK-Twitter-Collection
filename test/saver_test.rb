require "test_helper"

class SaverTest < Test::Unit::TestCase
  context "A default saver" do
    setup do
      @saver = Saver.new
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
  end
end
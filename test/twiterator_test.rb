require "test_helper"

class TwiteratorTest < Test::Unit::TestCase
  context "A default twiterator" do
    setup do
      $SAVER = Saver.new
      @base = Twitter::Base.new(Twitter::HTTPAuth.new('sam1vp', 'twAg60307', :user_agent => 'web_ecology_project'))
      $PULLER = Puller.new(@base)
    end
    context "set to search" do
      setup do
        @p = Twiterator.new(&SEARCH_ITER)
      end
      should "be able to iterate through all of the tweets in Search for a given term" do
        @p.twiterate({},{:search_query => 'test'})
      end
    end   
    context "set to user_tweets" do 
      setup do
        @p = Twiterator.new(&USER_TWEETS_ITER)
      end
      should "be able to iterate through all of a given User's available tweets" do
        @p.twiterate({}, {:user_id => 15019521})
      end
    end
    context "set to followers" do
      setup do
        @p = Twiterator.new(&FOLLOWERS_ITER)
      end
      should "be able to iterate through all of a given User's followers" do
        @p.twiterate({}, {:user_id => 15019521})
      end
    end
    context "set to friends" do
      setup do
        @p = Twiterator.new(&FRIENDS_ITER)
      end
      should "be able to iterate through all of a given User's friends" do
        @p.twiterate({}, {:user_id => 15019521})
      end
    end
  end
end
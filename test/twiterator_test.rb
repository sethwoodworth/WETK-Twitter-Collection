require "test_helper"

class TwiteratorTest < Test::Unit::TestCase
  context "A default twiterator" do
    setup do
      $SAVER = Saver.new
      @base = Twitter::Base.new(Twitter::HTTPAuth.new('sam1vp', 'twAg60307', :user_agent => 'web_ecology_project'))
      $PULLER = Puller.new(@base)
      db_user_info = TwitterAccount.create({:twitter_id => 15019521,:screen_name => 'sam1vp'})
      @test_user = SearchUser.new(:by_id => 15019521, :db_user_info => db_user_info)
    end
    context "set to search" do
      setup do
        @p = Twiterator.new()
      end
      should "be able to iterate through all of the tweets in Search for a given term" do
        @p.twiterate({},{:search_query => 'test'}, &SEARCH_ITER)
      end
    end   
    context "set to user_tweets" do 
             setup do
               @p = Twiterator.new()
             end
             should "be able to iterate through all of a given User's available tweets" do
               @p.twiterate({}, {:user_id => 15019521}, &USER_TWEETS_ITER)
             end
           end
     context "set to followers" do
        setup do
          @p = Twiterator.new()
        end
        should "be able to iterate through all of a given User's followers" do
          @p.twiterate({}, {:user => @test_user}, &FOLLOWERS_ITER)
        end
      end
        context "set to friends" do
          setup do
            @p = Twiterator.new()
          end
          should "be able to iterate through all of a given User's friends" do
            @p.twiterate({}, {:user => @test_user}, &FRIENDS_ITER)
          end
        end
  end
end
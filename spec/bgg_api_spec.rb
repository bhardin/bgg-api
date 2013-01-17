require 'rspec'
require 'bgg-api'
require 'webmock/rspec'

describe 'BGG Search' do

  it 'some results come back' do
    stub_request(:any, "http://www.boardgamegeek.com/xmlapi2/search").with(:query => {:query => 'Burgund', :type => 'boardgame'}).to_return(:body => File.new('sample_data/search?query=Burgund&type=boardgame'), :status => 200)

    bgg = BggApi.new
    results = bgg.search({:query => 'Burgund', :type => 'boardgame'})

    results.should_not be_nil
  end
end

describe 'BGG Thing' do
  it 'searches for and returns a thing' do
    stub_request(:any, "http://www.boardgamegeek.com/xmlapi2/thing").with(:query => {:id => '84876', :type => 'boardgame'}).to_return(:body => File.new('sample_data/thing?id=84876&type=boardgame'), :status => 200)

    bgg = BggApi.new
    results = bgg.thing({:id => '84876', :type => 'boardgame'})

    results.should_not be_nil
    results['item'][0]['id'].should == '84876'
  end
end

describe 'BGG Collection' do
  it 'retrieves a collection' do
    stub_request(:any, "http://www.boardgamegeek.com/xmlapi2/collection").with(:query => {:own => '1', :name => 'texasjdl', :type => 'boardgame'}).to_return(:body => File.new('sample_data/collection?username=texasjdl&own=1&excludesubtype=boardgameexpansion'), :status => 200)

    bgg = BggApi.new
    results = bgg.collection({:name => 'texasjdl', :own => '1', :type => 'boardgame'})

    results.should_not be_nil
    results['item'][0]['objectid'].should == '421'
  end
end

describe 'BGG Hot Items' do
  it 'retrieves the current hot boardgames' do
    stub_request(:any, "http://www.boardgamegeek.com/xmlapi2/hot").with(:query => {:type => 'boardgame'}).to_return(:body => File.new('sample_data/hot?type=boardgame'), :status => 200)

    bgg = BggApi.new
    results = bgg.hot({:type => 'boardgame'})

    results.should_not be_nil
    results['item'][0]['rank'].should == '1'
  end
end

describe 'BGG Plays' do
  it 'retrieves the plays for a user' do
    stub_request(:any, "http://www.boardgamegeek.com/xmlapi2/plays").with(:query => {:id => '84876', :username => 'texasjdl'}).to_return(:body => File.new('sample_data/plays?username=texasjdl&id=84876'), :status => 200)

    bgg = BggApi.new
    results = bgg.plays({:id => '84876', :username => 'texasjdl'})

    results.should_not be_nil
    results['total'].should == '27'
  end
end

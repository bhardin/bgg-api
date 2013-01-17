require 'rspec'
require 'bgg_api'
require 'webmock/rspec'

describe 'Specialized games search' do

  it 'should return a list of games hash when search is OK' do
    stub_request(:get, "http://www.boardgamegeek.com/xmlapi2/search?query=Burgund&type=boardgame").to_return(:body => File.new('sample_data/search?query=Burgund&type=boardgame'), :status => 200)
    results = BggApi.search_by_name('Burgund')
    results.is_a?(Array).should be_true
    results[0].should be == {:name=>"The Castles of Burgundy", :name_type=>"The Castles of Burgundy", :type=>"boardgame", :id=>84876}
    results[1].should be == {:name=>"The Castles of Burgundy: New Player Boards", :name_type=>"The Castles of Burgundy: New Player Boards", :type=>"boardgame", :id=>110926}
  end

  it 'should return nil if no game exists' do
    stub_request(:get, "http://www.boardgamegeek.com/xmlapi2/search?query=XXXXXXXXXXXX&type=boardgame").to_return(:body => File.new('sample_data/search?query=XXXXXXXX'), :status => 200)
    results = BggApi.search_by_name('XXXXXXXXXXXX')
    results.should be_nil
  end

  it 'should return nil in case of errors' do
    stub_request(:get, "http://www.boardgamegeek.com/xmlapi2/search?query=Burgund&type=boardgame").to_return(:body => File.new('sample_data/search?query=XXXXXXXX'), :status => 500)
    results = BggApi.search_by_name('Burgund')
    results.should be_nil
  end

end


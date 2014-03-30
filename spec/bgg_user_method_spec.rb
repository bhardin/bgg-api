# encoding: UTF-8
require 'spec_helper'

describe 'Specialized search by name' do

  it 'should return a list of games hash when search is OK' do
    stub_request(:get, "http://www.boardgamegeek.com/xmlapi2/search?query=Burgund&type=boardgame").to_return(:body => File.new('sample_data/search?query=Burgund&type=boardgame'), :status => 200)
    results = BggApi.search_by_name('Burgund')
    results.is_a?(Array).should be_true
    results[0].should be == {:name=>"The Castles of Burgundy", :type=>"boardgame", :id=>84876}
    results[1].should be == {:name=>"The Castles of Burgundy: New Player Boards", :type=>"boardgame", :id=>110926}
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

describe 'Specialized search by id' do
  it 'should return a game hash matching the id' do
    stub_request(:get, "http://www.boardgamegeek.com/xmlapi/boardgame/53424").to_return(:body => File.new('sample_data/35424.xml'), :status => 200)
    result = BggApi.search_boardgame_by_id(53424)
    result[:id].should == 53424
    result[:name].should == "Hexpack"
    result[:minplayers].should == "0"
    result[:maxplayers].should == "0"
    result[:age].should == "0"
    result[:yearpublished].should == "2008"
    result[:thumbnail].should ==  "http://cf.geekdo-images.com/images/pic350302_t.jpg"
    result[:image].should ==  "http://cf.geekdo-images.com/images/pic350302.jpg"
    result[:alternatenames].should == []
  end

  it 'should return a list of all the alternate names' do
    stub_request(:get, "http://www.boardgamegeek.com/xmlapi/boardgame/325").to_return(:body => File.new('sample_data/325.xml'), :status => 200)
    result = BggApi.search_boardgame_by_id(325)
    result[:id].should == 325
    result[:name].should == "Catan: Seafarers"
    result[:alternatenames].size.should == 24
    result[:alternatenames][0].should == "Catan: Navegantes"
    result[:alternatenames][4].should == "Catanin uudisasukkaat: Merenkävijät"
  end

  it 'should return nil in case of errors' do
    stub_request(:get, "http://www.boardgamegeek.com/xmlapi2/search?query=Burgund&type=boardgame").to_return(:body => File.new('sample_data/search?query=XXXXXXXX'), :status => 500)
    results = BggApi.search_by_name('Burgund')
    results.should be_nil
  end

end

describe 'Specialized play fetching' do
  it 'should return a users play history' do
    stub_request(:get, "http://www.boardgamegeek.com/xmlapi2/plays?page=1&username=ryanmacg").to_return(:body => File.new('sample_data/plays?username=ryanmacg'), :status => 200)
    results = BggApi.entire_user_plays('ryanmacg')
    results.count != 0
  end
  it 'should not return results for pages that have no plays' do
    stub_request(:get, "http://www.boardgamegeek.com/xmlapi2/plays?page=9999999999999&username=ryanmacg").to_return(:body => File.new('sample_data/plays?pages=9999999999999&username=ryanmacg'), :status => 500)
    results = BggApi.entire_user_plays('ryanmacg', 9999999999999)
    results.should be_nil
  end
end
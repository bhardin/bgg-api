# encoding: UTF-8
require 'spec_helper'

describe 'BggApi richer API call' do
  describe 'search_by_name' do

    it 'returns a list of games hash when search is OK' do
      query = 'http://www.boardgamegeek.com/xmlapi2/search?query=Burgund&type=boardgame'
      response_data = File.new('sample_data/search?query=Burgund&type=boardgame')

      stub_request(:get, query).to_return(body: response_data, status: 200)

      results = BggApi.search_by_name('Burgund')
      results.is_a?(Array).should be_true

      results[0].should be == {
        id: 84876,
        name: 'The Castles of Burgundy',
        type: 'boardgame',
      }
      results[1].should be == {
        id: 110926,
        name: 'The Castles of Burgundy: New Player Boards',
        type: 'boardgame',
      }
    end

    it 'returns nil if no game exists' do
      query = 'http://www.boardgamegeek.com/xmlapi2/search?query=XXXXXXXXXXXX&type=boardgame'
      response_data = File.new('sample_data/search?query=XXXXXXXX')

      stub_request(:get, query).to_return(body: response_data, status: 200)

      results = BggApi.search_by_name('XXXXXXXXXXXX')
      results.should be_nil
    end

    it 'returns nil in case of errors' do
      query = 'http://www.boardgamegeek.com/xmlapi2/search?query=Burgund&type=boardgame'
      response_data = File.new('sample_data/search?query=XXXXXXXX')

      stub_request(:get, query).to_return(body: response_data, status: 500)

      results = BggApi.search_by_name('Burgund')
      results.should be_nil
    end
  end

  describe 'search_boardgame_by_id' do
    it 'returns a game hash matching the id' do
      query = 'http://www.boardgamegeek.com/xmlapi/boardgame/53424'
      response_data = File.new('sample_data/35424.xml')

      stub_request(:get, query).to_return(body: response_data, status: 200)

      # not checking every field, so cherry-picking items instead of
      # comparing to a hash
      result = BggApi.search_boardgame_by_id(53424)
      result[:id].should   == 53424
      result[:name].should == 'Hexpack'

      result[:age].should            == '0'
      result[:alternatenames].should == []
      result[:maxplayers].should     == '0'
      result[:minplayers].should     == '0'
      result[:image].should          == 'http://cf.geekdo-images.com/images/pic350302.jpg'
      result[:thumbnail].should      == 'http://cf.geekdo-images.com/images/pic350302_t.jpg'
      result[:yearpublished].should  == '2008'
    end

    it 'returns a list of all the alternate names' do
      query = 'http://www.boardgamegeek.com/xmlapi/boardgame/325'
      response_data = File.new('sample_data/325.xml')

      stub_request(:get, query).to_return(body: response_data, status: 200)

      result = BggApi.search_boardgame_by_id(325)
      result[:id].should == 325
      result[:name].should == 'Catan: Seafarers'
      result[:alternatenames].size.should == 24
      result[:alternatenames][0].should == 'Catan: Navegantes'
      result[:alternatenames][4].should == 'Catanin uudisasukkaat: Merenkävijät'
    end

    it 'returns nil in case of errors' do
      query = 'http://www.boardgamegeek.com/xmlapi/boardgame/0'
      response_data = File.new('sample_data/0.xml')

      stub_request(:get, query).to_return(body: response_data, status: 200)

      results = BggApi.search_boardgame_by_id(0)
      results.should be_nil
    end

  end

  describe 'entire_user_plays' do
    it 'returns the play history for a user' do
      query = 'http://www.boardgamegeek.com/xmlapi2/plays?page=1&username=ryanmacg'
      response_data = File.new('sample_data/plays?username=ryanmacg')

      stub_request(:get, query).to_return(body: response_data, status: 200)

      results = BggApi.entire_user_plays('ryanmacg')
      results.count != 0
    end

    it 'does not return results for pages that have no plays' do
      query = 'http://www.boardgamegeek.com/xmlapi2/plays?page=9999999999999&username=ryanmacg'
      response_data = File.new('sample_data/plays?pages=9999999999999&username=ryanmacg')

      stub_request(:get, query).to_return(body: response_data, status: 500)

      results = BggApi.entire_user_plays('ryanmacg', 9999999999999)
      results.should be_nil
    end
  end
end

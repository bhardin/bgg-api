# encoding: UTF-8
require 'spec_helper'

describe BggGame do
  describe 'class method' do
    describe 'find_by_id' do
      it 'throws an ArgumentError when a non-integer is passed in' do
        expect{ BggGame.find_by_id('string instead') }.to raise_error(ArgumentError, 'invalid value for Integer(): "string instead"')
      end

      it 'throws an ArgumentError when a non-positive integer is passed in' do
        expect{ BggGame.find_by_id(0) }.to  raise_error(ArgumentError, 'game_id must be greater than 0!')
        expect{ BggGame.find_by_id(-1) }.to raise_error(ArgumentError, 'game_id must be greater than 0!')
      end

      it 'creates an object for a game that exists' do
        response_file = 'sample_data/thing?id=84876&type=boardgame'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/thing'

        stub_request(:any, request_url).with(query: {id: 84876, type: 'boardgame'}).to_return(body: File.open(response_file), status: 200)
        burgund = BggGame.find_by_id(84876)

        expect( burgund ).to be_a_kind_of(Object)
        expect( burgund.name ).to eq('The Castles of Burgundy')
        expect( burgund.names ).to match_array(['The Castles of Burgundy', 'Les Châteaux de Bourgogne', 'Die Burgen von Burgund'])
      end

      it 'throws an ArgumentError for a game that does not exist' do
        response_file = 'sample_data/thing?id=10000000&type=boardgame'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/thing'

        stub_request(:any, request_url).with(query: {id: 10000000, type: 'boardgame'}).to_return(body: File.open(response_file), status: 200)

        expect{ BggGame.find_by_id(10000000) }.to raise_error(ArgumentError, 'Game does not exist')
      end
    end
  end

  describe 'instance' do
    let(:burgund) { BggGame.find_by_id(84876) }
    before do
      response_file = 'sample_data/thing?id=84876&type=boardgame'
      request_url = 'http://www.boardgamegeek.com/xmlapi2/thing'

      stub_request(:any, request_url).
        with(query: {id: 84876, type: 'boardgame'}).
        to_return(body: File.open(response_file), status: 200)
    end

    it 'has id' do
      expect( burgund.id ).to eq(84876)
    end

    it 'has name' do
      expect( burgund.name ).to eq('The Castles of Burgundy')
    end

    it 'has names' do
      expect( burgund.names ).to match_array(['The Castles of Burgundy', 'Les Châteaux de Bourgogne', 'Die Burgen von Burgund'])
    end

    it 'has alternate names' do
      expect( burgund.alternate_names ).to match_array(['Les Châteaux de Bourgogne', 'Die Burgen von Burgund'])
    end

    it 'has artist_list' do
      expect( burgund.artist_list ).to match_array(['Harald Lieske', 'Julien Delval'])
    end

    it 'has description' do
      expect( burgund.description ).to match(/The game is set in the Burgundy region of High Medieval France\./)
    end

    it 'has designer_list' do
      expect( burgund.designer_list ).to match_array(['Stefan Feld'])
    end

    it 'has image' do
      expect( burgund.image ).to eq('http://cf.geekdo-images.com/images/pic1176894.jpg')
    end

    it 'has min_players' do
      expect( burgund.min_players ).to eq(2)
    end

    it 'has max_players' do
      expect( burgund.max_players ).to eq(4)
    end

    it 'has minimum_age' do
      expect( burgund.minimum_age ).to eq(12)
    end

    it 'has playing_time' do
      expect( burgund.playing_time ).to eq(90)
    end

    it 'has publisher_list' do
      expect( burgund.publisher_list ).to match_array(['Ravensburger', 'alea'])
    end

    it 'has thumbnail' do
      expect( burgund.thumbnail ).to eq('http://cf.geekdo-images.com/images/pic1176894_t.jpg')
    end

    it 'has year_published' do
      expect( burgund.year_published ).to eq(2011)
    end
  end
end

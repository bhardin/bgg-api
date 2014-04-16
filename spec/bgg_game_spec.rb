# encoding: UTF-8
require 'spec_helper'

describe Bgg::Game do
  describe 'class method' do
    describe 'find_by_id' do
      it 'throws an ArgumentError when a non-integer is passed in' do
        expect{ Bgg::Game.find_by_id('string instead') }.to raise_error(ArgumentError, 'invalid value for Integer(): "string instead"')
      end

      it 'throws an ArgumentError when a non-positive integer is passed in' do
        expect{ Bgg::Game.find_by_id(0) }.to  raise_error(ArgumentError, 'game_id must be greater than 0!')
        expect{ Bgg::Game.find_by_id(-1) }.to raise_error(ArgumentError, 'game_id must be greater than 0!')
      end

      it 'creates an object for a game that exists' do
        response_file = 'sample_data/thing?id=84876&type=boardgame'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/thing'

        stub_request(:any, request_url).with(query: {id: 84876, type: 'boardgame'}).to_return(body: File.open(response_file), status: 200)
        burgund = Bgg::Game.find_by_id(84876)

        expect( burgund ).to be_a_kind_of(Object)
        expect( burgund.name ).to eq('The Castles of Burgundy')
        expect( burgund.names ).to match_array(['The Castles of Burgundy', 'Les Châteaux de Bourgogne', 'Die Burgen von Burgund'])
      end

      it 'throws an ArgumentError for a game that does not exist' do
        response_file = 'sample_data/thing?id=10000000&type=boardgame'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/thing'

        stub_request(:any, request_url).with(query: {id: 10000000, type: 'boardgame'}).to_return(body: File.open(response_file), status: 200)

        expect{ Bgg::Game.find_by_id(10000000) }.to raise_error(ArgumentError, 'Game does not exist')
      end
    end
  end

  describe 'instance' do
    let(:burgund) { Bgg::Game.find_by_id(84876) }

    before do
      response_file = 'sample_data/thing?id=84876&type=boardgame'
      request_url = 'http://www.boardgamegeek.com/xmlapi2/thing'

      stub_request(:any, request_url).
        with(query: {id: 84876, type: 'boardgame'}).
        to_return(body: File.open(response_file), status: 200)
    end

    describe '.id' do
      it 'exists' do
        expect( burgund ).to respond_to(:id)
      end

      it 'returns the BGG Thing id' do
        expect( burgund.id ).to eq(84876)
      end
    end

    describe '.name' do
      it 'exists' do
        expect( burgund ).to respond_to(:name)
      end

      it 'returns the primary name' do
        expect( burgund.name ).to eq('The Castles of Burgundy')
      end
    end

    describe '.names' do
      it 'exists' do
        expect( burgund ).to respond_to(:names)
      end

      it 'returns a list of all names -- primary and alternates' do
        expect( burgund.names ).to match_array(['The Castles of Burgundy', 'Les Châteaux de Bourgogne', 'Die Burgen von Burgund'])
      end
    end

    describe '.alternate_names' do
      it 'exists' do
        expect( burgund ).to respond_to(:alternate_names)
      end

      it 'returns a list of the alternate/foreign names -- without the primary name' do
        expect( burgund.alternate_names ).to match_array(['Les Châteaux de Bourgogne', 'Die Burgen von Burgund'])
      end
    end

    describe '.artists' do
      it 'exists' do
        expect( burgund ).to respond_to(:artists)
      end

      it 'returns a list of the game artists' do
        expect( burgund.artists ).to match_array(['Harald Lieske', 'Julien Delval'])
      end
    end

    describe '.description' do
      it 'exists' do
        expect( burgund ).to respond_to(:description)
      end

      it 'returns the text description of the game' do
        expect( burgund.description ).to match(/The game is set in the Burgundy region of High Medieval France\./)
        expect( burgund.description.length ).to eq(1049)
      end
    end

    describe '.designers' do
      it 'exists' do
        expect( burgund ).to respond_to(:designers)
      end

      it 'returns a list of the designers' do
        expect( burgund.designers ).to match_array(['Stefan Feld'])
      end
    end

    describe '.image' do
      it 'exists' do
        expect( burgund ).to respond_to(:image)
      end

      it 'returns a URL to an image for the game' do
        expect( burgund.image ).to eq('http://cf.geekdo-images.com/images/pic1176894.jpg')
      end
    end

    describe '.min_players' do
      it 'exists' do
        expect( burgund ).to respond_to(:min_players)
      end

      it 'returns the minimum number of players' do
        expect( burgund.min_players ).to eq(2)
      end
    end

    describe '.max_players' do
      it 'exists' do
        expect( burgund ).to respond_to(:max_players)
      end

      it 'returns the maximum number of players' do
        expect( burgund.max_players ).to eq(4)
      end
    end

    describe '.minimum_recommended_age' do
      it 'exists' do
        expect( burgund ).to respond_to(:recommended_minimum_age)
      end

      it 'returns the recommended minimum age' do
        expect( burgund.recommended_minimum_age ).to eq(12)
      end

      it 'returns nil if there is no recommended minimum age' do
        pending 'need to restructure how tests are run to inject this data'
        expect( burgund.recommended_minimum_age ).to eq(nil)
      end
    end

    describe '.playing_time' do
      it 'exists' do
        expect( burgund ).to respond_to(:playing_time)
      end

      it 'has playing_time' do
        expect( burgund.playing_time ).to eq(90)
      end
    end

    describe '.publishers' do
      it 'exists' do
        expect( burgund ).to respond_to(:publishers)
      end

      it 'returns a list of publisher names' do
        expect( burgund.publishers ).to match_array(['Ravensburger', 'alea'])
      end
    end

    describe '.thumbnail' do
      it 'exists' do
        expect( burgund ).to respond_to(:thumbnail)
      end

      it 'returns a URL to a thumbnail' do
        expect( burgund.thumbnail ).to eq('http://cf.geekdo-images.com/images/pic1176894_t.jpg')
      end
    end

    describe '.year_published' do
      it 'exists' do
        expect( burgund ).to respond_to(:year_published)
      end

      it 'returns the only year published' do
        expect( burgund.year_published ).to eq(2011)
      end

      it 'returns the earliest year published' do
        pending 'need to restructure how tests are run to inject this data'
        expect( burgund.year_published ).to eq(2011)
      end
    end

    describe '.mechanics' do
      it 'exists' do
        expect( burgund ).to respond_to(:mechanics)
      end

      it 'returns the mechanisms used in the game' do
        expect( burgund.mechanics ).to match_array(['Dice Rolling', 'Set Collection', 'Tile Placement'])
      end
    end

    describe '.categories' do
      it 'exists' do
        expect( burgund ).to respond_to(:categories)
      end

      it 'returns the minimum number of players' do
        expect( burgund.categories ).to match_array(['Dice', 'Medieval', 'Territory Building'])
      end
    end

    describe '.families' do
      it 'exists' do
        expect( burgund ).to respond_to(:families)
      end

      it 'returns the minimum number of players' do
        expect( burgund.families ).to match_array(['Alea Big Box', 'Country: France'])
      end
    end
  end
end

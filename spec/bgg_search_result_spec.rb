# encoding: UTF-8
require 'spec_helper'

describe BggSearchResult do
  describe 'instance' do
    let(:item_data) { {'type'=>'boardgame',
                       'id'=>'84876',
                       'name'=>[{'type'=>'primary', 'value'=>'The Castles of Burgundy'}],
                       'yearpublished'=>[{'value'=>'2011'}]} }
    let(:search_result) { BggSearchResult.new(item_data) }

    describe '.id' do
      it 'exists' do
        expect( search_result ).to respond_to(:id)
      end

      it 'returns correct value' do
        expect( search_result.id ).to eq(84876)
      end
    end

    describe '.name' do
      it 'exists' do
        expect( search_result ).to respond_to(:name)
      end

      it 'returns the correct value' do
        expect( search_result.name ).to eq('The Castles of Burgundy')
      end
    end

    describe '.type' do
      it 'exists' do
        expect( search_result ).to respond_to(:type)
      end

      it 'returns boardgame when it is a boardgame' do
        expect( search_result.type ).to eq('boardgame')
      end
    end

    describe '.year_published' do
      it 'exists' do
        expect( search_result ).to respond_to(:year_published)
      end

      it 'returns the year it was published' do
        expect( search_result.year_published ).to eq(2011)
      end
    end

    describe '.game' do
      it 'exists' do
        expect( search_result ).to respond_to(:game)
      end

      it 'returns a BggGame object corresponding to the entry' do
        response_file = 'sample_data/thing?id=84876&type=boardgame'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/thing'

        stub_request(:any, request_url).with(query: {id: 84876, type: 'boardgame'}).to_return(body: File.open(response_file), status: 200)

        game = search_result.game

        expect( game ).to be_instance_of(BggGame)
        expect( game.name ).to eq('The Castles of Burgundy')
        expect( game.designers ).to eq(['Stefan Feld'])
      end
    end
  end
end

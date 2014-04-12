# encoding: UTF-8
require 'spec_helper'

describe BggPlay do
  describe 'instance' do
    let(:item_data) { {'id'=>'7680984',
                       'date'=>'2012-06-23',
                       'quantity'=>'1',
                       'length'=>'0',
                       'incomplete'=>'0',
                       'nowinstats'=>'0',
                       'location'=>'',
                       'item'=>[{'name'=>'Cheeky Monkey', 'objecttype'=>'thing', 'objectid'=>'29773', 'subtypes'=>[{'subtype'=>[{'value'=>'boardgame'}]}]}]} }

    let(:item) { BggPlay.new(item_data) }

    describe '.id' do
      it 'exists' do
        expect( item ).to respond_to(:id)
      end

      it 'returns correct value' do
        expect( item.id ).to eq(7680984)
      end
    end

    describe '.date' do
      it 'exists' do
        expect( item ).to respond_to(:date)
      end

      # FIXME: should move to an actual date object
      it 'returns the correct value' do
        expect( item.date ).to eq('2012-06-23')
      end
    end

    describe '.quantity' do
      it 'exists' do
        expect( item ).to respond_to(:quantity)
      end

      it 'returns the correct value' do
        expect( item.quantity ).to eq(1)
      end
    end

    describe '.length' do
      it 'exists' do
        expect( item ).to respond_to(:length)
      end

      it 'returns the correct value' do
        expect( item.length ).to eq(0)
      end
    end

    describe '.incomplete?' do
      it 'exists' do
        expect( item ).to respond_to(:incomplete?)
      end

      it 'returns true when incomplete == 0' do
        item_data['incomplete'] = '0'
        expect( item.incomplete? ).to eq(false)
      end

      it 'returns true when incomplete == 1' do
        item_data['incomplete'] = '1'
        expect( item.incomplete? ).to eq(true)
      end
    end

    describe '.location' do
      it 'exists' do
        expect( item ).to respond_to(:location)
      end

      it 'returns empty string when it is empty' do
        expect( item.location ).to eq('')
      end

      it 'returns a string when it is filled in' do
        item_data['location'] = 'BGGCon!'
        expect( item.location ).to eq('BGGCon!')
      end
    end

    describe '.nowinstats?' do
      it 'exists' do
        expect( item ).to respond_to(:nowinstats?)
      end

      it 'returns true when nowinstats == 1' do
        item_data['nowinstats'] = '1'
        expect( item.nowinstats? ).to eq(true)
      end

      it 'returns false when nowinstats == 0' do
        item_data['nowinstats'] = '0'
        expect( item.nowinstats? ).to eq(false)
      end
    end

    describe '.players' do
      it 'exists' do
        expect( item ).to respond_to(:players)
      end

      it 'returns the list of players' do
        expect( item.players ).to match_array([])
      end
    end

    describe '.game_name' do
      it 'exists' do
        expect( item ).to respond_to(:game_name)
      end

      it 'returns the correct value' do
        expect( item.game_name ).to eq('Cheeky Monkey')
      end
    end

    describe '.game_id' do
      it 'exists' do
        expect( item ).to respond_to(:game_id)
      end

      it 'returns the correct value' do
        expect( item.game_id ).to eq(29773)
      end
    end

    describe '.game_type' do
      it 'exists' do
        expect( item ).to respond_to(:game_type)
      end

      it 'returns the correct value' do
        expect( item.game_type ).to eq('boardgame')
      end
    end

    describe '.game' do
      it 'exists' do
        expect( item ).to respond_to(:game)
      end

      it 'returns a BggGame object corresponding to the entry' do
        response_file = 'sample_data/thing?id=29773&type=boardgame'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/thing'

        stub_request(:any, request_url).
          with(query: {id: 29773, type: 'boardgame'}).
          to_return(body: File.open(response_file), status: 200)

        game = item.game

        expect( game ).to be_instance_of(BggGame)
        expect( game.name ).to eq('Cheeky Monkey')
        expect( game.designers ).to eq(['Reiner Knizia'])
      end
    end
  end
end

# encoding: UTF-8
require 'spec_helper'

describe BggCollectionItem do
  describe 'instance' do
    let(:item_data) { {'objecttype'=>'thing',
                       'objectid'=>'70512',
                       'subtype'=>'boardgame',
                       'collid'=>'11455824',
                       'name'=>[{'sortindex'=>'1', 'content'=>'Luna'}],
                       'yearpublished'=>['2010'],
                       'image'=>['http://cf.geekdo-images.com/images/pic802342.jpg'],
                       'thumbnail'=>['http://cf.geekdo-images.com/images/pic802342_t.jpg'],
                       'status'=>[{'own'=>'1', 'prevowned'=>'0', 'fortrade'=>'0', 'want'=>'0', 'wanttoplay'=>'0', 'wanttobuy'=>'0', "wishlist"=>'0', 'preordered'=>'0', 'lastmodified'=>'2007-02-18 21:20:51'}],
                       'numplays'=>['7'],
                       'comment'=>['Never played.']} }

    let(:item) { BggCollectionItem.new(item_data) }

    describe '.id' do
      it 'exists' do
        expect( item ).to respond_to(:id)
      end

      it 'returns correct value' do
        expect( item.id ).to eq(70512)
      end
    end

    describe '.name' do
      it 'exists' do
        expect( item ).to respond_to(:name)
      end

      it 'returns the correct value' do
        expect( item.name ).to eq('Luna')
      end
    end

    describe '.collection_id' do
      it 'exists' do
        expect( item ).to respond_to(:collection_id)
      end

      it 'returns the correct value' do
        expect( item.collection_id ).to eq(11455824)
      end
    end

    describe '.owned?' do
      it 'exists' do
        expect( item ).to respond_to(:owned?)
      end

      it 'returns true when own == 1' do
        item_data['status'][0]['own'] = '1'
        expect( item.owned? ).to eq(true)
      end

      it 'returns true when want == 0' do
        item_data['status'][0]['own'] = '0'
        expect( item.owned? ).to eq(false)
      end
    end

    describe '.wanted?' do
      it 'exists' do
        expect( item ).to respond_to(:wanted?)
      end

      it 'returns true when want == 0' do
        item_data['status'][0]['want'] = '0'
        expect( item.wanted? ).to eq(false)
      end

      it 'returns true when want == 1' do
        item_data['status'][0]['want'] = '1'
        expect( item.wanted? ).to eq(true)
      end
    end

    describe '.for_trade?' do
      it 'exists' do
        expect( item ).to respond_to(:for_trade?)
      end

      it 'returns false when fortrade == 0' do
        item_data['status'][0]['fortrade'] = '0'
        expect( item.for_trade? ).to eq(false)
      end

      it 'returns true when fortrade == 1' do
        item_data['status'][0]['fortrade'] = '1'
        expect( item.for_trade? ).to eq(true)
      end
    end

    describe '.played?' do
      it 'exists' do
        expect( item ).to respond_to(:played?)
      end

      it 'returns true when play_count > 0' do
        item_data['numplays'][0] = '7'
        expect( item.played? ).to eq(true)
      end

      it 'returns false when play_count == 0' do
        item_data['numplays'][0] = '0'
        expect( item.played? ).to eq(false)
      end
    end

    describe '.want_to_buy?' do
      it 'exists' do
        expect( item ).to respond_to(:want_to_buy?)
      end

      it 'returns true when wanttobuy == 1' do
        item_data['status'][0]['wanttobuy'] = '1'
        expect( item.want_to_buy? ).to eq(true)
      end

      it 'returns false when wanttobuy == 0' do
        item_data['status'][0]['wanttobuy'] = '0'
        expect( item.want_to_buy? ).to eq(false)
      end
    end

    describe '.preordered?' do
      it 'exists' do
        expect( item ).to respond_to(:preordered?)
      end

      it 'returns true when preordered == 1' do
        item_data['status'][0]['preordered'] = '1'
        expect( item.preordered? ).to eq(true)
      end

      it 'returns false when preordered == 0' do
        item_data['status'][0]['preordered'] = '0'
        expect( item.preordered? ).to eq(false)
      end
    end

    describe '.want_to_play?' do
      it 'exists' do
        expect( item ).to respond_to(:want_to_play?)
      end

      it 'returns true when wanttoplay == 1' do
        item_data['status'][0]['wanttoplay'] = '1'
        expect( item.want_to_play? ).to eq(true)
      end

      it 'returns false when wanttoplay == 0' do
        item_data['status'][0]['wanttoplay'] = '0'
        expect( item.want_to_play? ).to eq(false)
      end
    end

    describe '.published?' do
      it 'exists' do
        expect( item ).to respond_to(:published?)
      end

      it 'returns true when yearpublished exists' do
        expect( item.published? ).to eq(true)
      end

      it 'returns false when yearpublished does not exist' do
        item_data.delete('yearpublished')
        expect( item.published? ).to eq(false)
      end
    end

    describe '.type' do
      it 'exists' do
        expect( item ).to respond_to(:type)
      end

      it 'returns boardgame when it is a boardgame' do
        expect( item.type ).to eq('boardgame')
      end
    end

    describe '.play_count' do
      it 'exists' do
        expect( item ).to respond_to(:play_count)
      end

      it 'returns the correct value' do
        expect( item.play_count ).to eq(7)
      end
    end

    describe '.year_published' do
      it 'exists' do
        expect( item ).to respond_to(:year_published)
      end

      it 'returns the correct value' do
        expect( item.year_published ).to eq(2010)
      end

      it 'returns 0 if it is not published' do
        item_data.delete('yearpublished')
        expect( item.year_published ).to eq(0)
      end
    end

    describe '.thumbnail' do
      it 'exists' do
        expect( item ).to respond_to(:thumbnail)
      end

      it 'returns the correct value' do
        expect( item.thumbnail ).to eq('http://cf.geekdo-images.com/images/pic802342_t.jpg')
      end
    end

    describe '.image' do
      it 'exists' do
        expect( item ).to respond_to(:image)
      end

      it 'returns the correct value' do
        expect( item.image ).to eq('http://cf.geekdo-images.com/images/pic802342.jpg')
      end
    end

    describe '.comment' do
      it 'exists' do
        expect( item ).to respond_to(:comment)
      end

      it 'returns the correct value' do
        expect( item.comment ).to eq('Never played.')
      end
    end

    describe '.game' do
      it 'exists' do
        expect( item ).to respond_to(:game)
      end

      it 'returns a BggGame object corresponding to the entry' do
        response_file = 'sample_data/thing?id=70512&type=boardgame'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/thing'

        stub_request(:any, request_url).
          with(query: {id: 70512, type: 'boardgame'}).
          to_return(body: File.open(response_file), status: 200)

        game = item.game

        expect( game ).to be_instance_of(BggGame)
        expect( game.name ).to eq('Luna')
        expect( game.designer_list ).to eq(['Stefan Feld'])
      end
    end
  end
end

require 'spec_helper'

describe Bgg::Result::Collection::Item do
  let(:item_xml) { Nokogiri.XML(xml_string) }
  let(:xml_string) { '<items><item/></items>' }
  let(:request) { double('Bgg::Request::Collection') }

  subject { Bgg::Result::Collection::Item.new(item_xml.at_xpath('items/item'), request) }

  before do
    request.stub(:params).and_return( {} )
  end

  it { expect( subject ).to be_a Bgg::Result::Item }

  context 'without data' do
    its(:average_rating) { should eq nil }
    its(:bgg_rating)     { should eq nil }
    its(:collection_id)  { should eq nil }
    its(:comment)        { should eq nil }
    its(:for_trade?)     { should eq nil }
    its(:id)             { should eq nil }
    its(:image)          { should eq nil }
    its(:name)           { should eq nil }
    its(:last_modified)  { should eq nil }
    its(:own_count)      { should eq nil }
    its(:owned?)         { should eq nil }
    its(:play_count)     { should eq nil }
    its(:play_time)      { should eq nil }
    its(:played?)        { should eq nil }
    its(:players)        { should eq nil }
    its(:preordered?)    { should eq nil }
    its(:published?)     { should eq nil }
    its(:theme_ranks)    { should eq nil }
    its(:thumbnail)      { should eq nil }
    its(:type)           { should eq nil }
    its(:type_rank)      { should eq nil }
    its(:user_rating)    { should eq nil }
    its(:want_to_buy?)   { should eq nil }
    its(:want_to_play?)  { should eq nil }
    its(:wanted?)        { should eq nil }
    its(:year_published) { should eq nil }
  end

  context 'with data' do
    let(:average_rating) { 7.63834 }
    let(:bgg_rating) { 7.34567 }
    let(:collection_id) { 5678 }
    let(:comment) { 'p' }
    let(:id) { 1234 }
    let(:image) { 'hijk' }
    let(:last_modified) { Time.new('2001-01-01') }
    let(:max_players) { 4 }
    let(:min_players) { 2 }
    let(:name) { 'defg' }
    let(:own_count) { 123456 }
    let(:play_count) { 2 }
    let(:play_time) { 120 }
    let(:status) { 1 }
    let(:theme_rank_id) { 789 }
    let(:thumbnail) { 'lmno' }
    let(:type) { 'abc' }
    let(:type_rank) { 987 }
    let(:user_rating) { 9.5 }
    let(:year_published) { 2014 }
    let(:xml_string) { "
      <items>
        <item objectid='#{id}' subtype='#{type}' collid='#{collection_id}'>
          <name>#{name}</name>
          <yearpublished>#{year_published}</yearpublished>
          <image>#{image}</image>
          <thumbnail>#{thumbnail}</thumbnail>
          <stats minplayers='#{min_players}'
                 maxplayers='#{max_players}'
                 playingtime='#{play_time}'
                 numowned='#{own_count}'>
            <rating value='#{user_rating}'>
              <average value='#{average_rating}'/>
              <bayesaverage value='#{bgg_rating}'/>
              <ranks>
                <rank type='subtype' value='#{type_rank}'/>
                <rank type='family' id='#{theme_rank_id}'/>
                <rank type='family'/>
              </ranks>
            </rating>
          </stats>
          <status own='#{status}'
                  prevowned='#{status}'
                  fortrade='#{status}'
                  want='#{status}'
                  wanttoplay='#{status}'
                  wanttobuy='#{status}'
                  wishlist='#{status}'
                  preordered='#{status}'
                  lastmodified='#{last_modified}'/>
          <numplays>#{play_count}</numplays>
          <comment>#{comment}</comment>
        </item>
      </items>" }

    context 'default fields that always appear' do
      before do
        request.stub(:params).and_return( { brief: 1, stats: 0 } )
      end

      its(:collection_id)  { should eq collection_id }
      its(:id)             { should eq id }
      its(:last_modified)  { should eq last_modified }
      its(:name)           { should eq name }
      its(:type)           { should eq type }

      context 'booleans true' do
        let(:status)         { 1 }
        its(:for_trade?)     { should eq true }

        its(:owned?)         { should eq true }
        its(:preordered?)    { should eq true }
        its(:want_to_buy?)   { should eq true }
        its(:want_to_play?)  { should eq true }
        its(:wanted?)        { should eq true }
      end

      context 'booleans false' do
        let(:status)     { 0 }

        its(:for_trade?)     { should eq false }
        its(:owned?)         { should eq false }
        its(:preordered?)    { should eq false }
        its(:want_to_buy?)   { should eq false }
        its(:want_to_play?)  { should eq false }
        its(:wanted?)        { should eq false }
      end
    end

    context 'brief true in request params' do
      before do
        request.stub(:params).and_return( { brief: 1 } )
      end

      its(:comment)        { should eq nil }
      its(:image)          { should eq nil }
      its(:play_count)     { should eq nil }
      its(:played?)        { should eq nil }
      its(:published?)     { should eq nil }
      its(:thumbnail)      { should eq nil }
      its(:year_published) { should eq nil }
    end

    context 'brief false in request params' do
      before do
        request.stub(:params).and_return( { brief: 0 } )
      end

      its(:comment)        { should eq comment }
      its(:image)          { should eq image }
      its(:play_count)     { should eq play_count }
      its(:thumbnail)      { should eq thumbnail }
      its(:year_published) { should eq year_published }

      context 'booleans true' do
        let(:play_count)     { 1 }
        let(:year_published) { 2014 }

        its(:played?)        { should eq true }
        its(:published?)     { should eq true }
      end

      context 'booleans false' do
        let(:play_count) { 0 }
        let(:year_published) { 0 }

        its(:played?)        { should eq false }
        its(:published?)     { should eq false }
      end
    end

    context 'stats true in request params' do
      before do
        request.stub(:params).and_return( { stats: 1 } )
      end

      its(:average_rating) { should eq average_rating }
      its(:bgg_rating)     { should eq bgg_rating }
      its(:own_count)      { should eq own_count }
      its(:play_time)      { should eq play_time }
      its(:players)        { should eq min_players..max_players }
      its(:type_rank)      { should eq type_rank }
      its(:user_rating)    { should eq user_rating }

      it do
        expect( subject.theme_ranks.count ).to eq 2
        expect( subject.theme_ranks.first ).to be_a Bgg::Result::Collection::Item::Rank
        expect( subject.theme_ranks.first.id ).to eq theme_rank_id
      end
    end

    context 'stats false in request params' do
      before do
        request.stub(:params).and_return(  { stats: 0 } )
      end

      its(:average_rating) { should eq nil }
      its(:bgg_rating)     { should eq nil }
      its(:own_count)      { should eq nil }
      its(:play_time)      { should eq nil }
      its(:players)        { should eq nil }
      its(:theme_ranks)    { should eq nil }
      its(:type_rank)      { should eq nil }
      its(:user_rating)    { should eq nil }
    end

    describe '#game' do
      #TODO refactor once Things have been coverted
      let(:response_file) { 'sample_data/thing?id=70512&type=boardgame' }
      let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/thing' }

      before do
        stub_request(:any, request_url).
          with(query: {id: 1234, type: 'boardgame'}).
          to_return(body: File.open(response_file), status: 200)
      end

      it 'returns a Bgg::Game object corresponding to the entry' do
        expect( subject.game ).to be_instance_of(Bgg::Game)
      end
    end
  end

  context 'with live data' do
    let(:response_file)  { "sample_data/collection.xml" }
    let(:xml_string)     { File.open(response_file) }

    before do
      request.stub(:params).and_return( { stats: 1 } )
    end

    its(:average_rating) { should_not eq nil }
    its(:bgg_rating)     { should_not eq nil }
    its(:collection_id)  { should_not eq nil }
    its(:comment)        { should_not eq nil }
    its(:for_trade?)     { should_not eq nil }
    its(:id)             { should_not eq nil }
    its(:image)          { should_not eq nil }
    its(:name)           { should_not eq nil }
    its(:last_modified)  { should_not eq nil }
    its(:own_count)      { should_not eq nil }
    its(:owned?)         { should_not eq nil }
    its(:play_count)     { should_not eq nil }
    its(:play_time)      { should_not eq nil }
    its(:played?)        { should_not eq nil }
    its(:players)        { should_not eq nil }
    its(:preordered?)    { should_not eq nil }
    its(:published?)     { should_not eq nil }
    its(:theme_ranks)    { should_not eq nil }
    its(:thumbnail)      { should_not eq nil }
    its(:type)           { should_not eq nil }
    its(:type_rank)      { should_not eq nil }
    its(:user_rating)    { should_not eq nil }
    its(:want_to_buy?)   { should_not eq nil }
    its(:want_to_play?)  { should_not eq nil }
    its(:wanted?)        { should_not eq nil }
    its(:year_published) { should_not eq nil }
  end

end

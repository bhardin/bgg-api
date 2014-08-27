require 'spec_helper'

describe Bgg::Result::Plays do
  let(:params) { {} }
  let(:play1) { '<play/>' }
  let(:play2) { '<play/>' }
  let(:request) { double('Bgg::Request::Plays') }
  let(:xml_string) { "<plays>
                        #{play1}
                        #{play2}
                      </plays>" }
  subject { Bgg::Result::Plays.new(Nokogiri.XML(xml_string), request) }

  before do
    request.stub(:params).and_return(params)
  end

  context 'a result container' do
    it { expect( subject ).to respond_to :request, :xml }
    its(:request_params) { should be_a Hash }
    its(:count) { should eq 2 }
    it { expect( subject.first ).to be_instance_of subject.class::Play }
  end

  context 'without data' do
    its(:page)           { should eq 1 }
    its(:thing_id)       { should eq nil }
    its(:total_count)    { should eq nil }
    its(:username)       { should eq nil }

    it { expect( subject.find_by_date Time.now ).to eq [] }
    it { expect( subject.find_by_location 'location' ).to eq [] }
    it { expect( subject.find_by_thing_id 1234 ).to eq [] }
    it { expect( subject.find_by_thing_name 'name' ).to eq [] }

    its(:board_game_expansions)      { should eq [] }
    its(:board_game_implementations) { should eq [] }
    its(:board_games)                { should eq [] }
    its(:rpg_items)                  { should eq [] }
    its(:video_games)                { should eq [] }
  end

  context 'with data' do
    let(:page) { 2 }
    let(:thing_id) { 5678 }
    let(:total_count) { 101 }
    let(:username) { 'my_user' }
    let(:params) { { id: thing_id, 
                     username: username,
                     page: page } }
    let(:xml_string) { "<plays total='#{total_count}'>
                          #{play1}
                          #{play2}
                        </plays>" }

    its(:page)           { should eq page }
    its(:thing_id)       { should eq thing_id }
    its(:total_count)    { should eq total_count }
    its(:username)       { should eq username }

    describe '#find_by_date' do
      let(:date1) { Date.new(2000, 1, 1) }
      let(:date2) { Date.new(2001, 1, 1) }
      let(:play1) { "<play date='#{date1.to_s}'/>" }
      let(:play2) { "<play date='#{date2.to_s}'/>" }

      it do
        expect( subject.find_by_date(date1).count ).to eq 1
        expect( subject.find_by_date(date1..date2).count ).to eq 2
      end
    end

    describe '#find_by_location' do
      let(:play1) { '<play location="my location"/>' }
      let(:play2) { '<play location="no location"/>' }

      it { expect( subject.find_by_location('my location').count ).to eq 1 }
    end

    describe '#find_by_thing_id' do
      let(:play1) { '<play><item objectid="1234"/></play>' }
      let(:play2) { '<play><item objectid="9876"/></play>' }

      it { expect( subject.find_by_thing_id(1234).count ).to eq 1 }
    end

    describe '#find_by_thing_name' do
      let(:play1) { '<play><item name="my name"/></play>' }
      let(:play2) { '<play><item name="no name"/></play>' }

      it { expect( subject.find_by_thing_name('my name').count ).to eq 1 }
    end

    context 'find by types' do
      let(:play1) { '<play><item><subtypes>
                       <subtype value="boardgameexpansion"/>
                       <subtype value="boardgameimplementation"/>
                       <subtype value="boardgame"/>
                       <subtype value="rpgitem"/>
                       <subtype value="videogame"/>
                     </subtype></items></play>' }
      let(:play2) { '<play><item><subtypes><subtype value="no"/></subtype></items></play>' }

      its(:board_game_expansions) { should have(1).item }
      its(:board_game_implementations) { should have(1).item }
      its(:board_games) { should have(1).item }
      its(:rpg_items) { should have(1).item }
      its(:video_games) { should have(1).item }
    end
  end

  context 'with live data' do
    let(:response_file)  { 'sample_data/plays.xml' }
    let(:xml_string)     { File.open(response_file) }
    let(:params) { { id: '121', username: 'craineum' } }

    its(:page)           { should_not eq nil }
    its(:thing_id)       { should_not eq nil }
    its(:total_count)    { should_not eq nil }
    its(:username)       { should_not eq nil }

    it { expect( subject.find_by_date Date.parse('09-06-2012') ).to_not eq [] }
    it { expect( subject.find_by_location 'Home, Portsmouth, NH' ).to_not eq [] }
    it { expect( subject.find_by_thing_id 121 ).to_not eq [] }
    it { expect( subject.find_by_thing_name 'Dune' ).to_not eq [] }

    its(:board_games)    { should_not eq [] }
  end
end

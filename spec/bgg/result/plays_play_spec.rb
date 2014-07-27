require 'spec_helper'

describe Bgg::Result::Plays::Play do
  let(:item_xml) { Nokogiri.XML(xml_string) }
  let(:request) { double('bgg_reqest_play') }
  let(:xml_string) { '<plays><play/></plays>' }

  subject { Bgg::Result::Plays::Play.new(item_xml.at_xpath('plays/play'), request) }

  before do
    request.stub(:params).and_return( {} )
  end

  context 'without data' do
    its(:comment)        { should eq nil }
    its(:date)           { should eq nil }
    its(:id)             { should eq nil }
    its(:incomplete?)    { should eq nil }
    its(:length)         { should eq nil }
    its(:location)       { should eq nil }
    its(:name)           { should eq nil }
    its(:now_in_stats?)  { should eq nil }
    its(:players)        { should eq nil }
    its(:quantity)       { should eq nil }
    its(:type)           { should eq nil }
    its(:types)          { should eq nil }
    its(:winner)         { should eq nil }

    describe Bgg::Result::Plays::Play::Player do
      let(:xml_string) { '<plays><play><players><player/></players></play></plays>' }

      subject { Bgg::Result::Plays::Play::Player.new(item_xml.at_xpath('plays/play/players/player'), request) }

      its(:color)          { should eq nil }
      its(:id)             { should eq nil }
      its(:name)           { should eq nil }
      its(:new?)           { should eq nil }
      its(:rating)         { should eq nil }
      its(:score)          { should eq nil }
      its(:start_position) { should eq nil }
      its(:username)       { should eq nil }
      its(:winner?)        { should eq nil }
    end
  end

  context 'with data' do
    let(:comment)        { 'abc' }
    let(:date)           { Date.today }
    let(:id)             { 1234 }
    let(:incomplete)     { 0 }
    let(:length)         { 56 }
    let(:location)       { 'def' }
    let(:name)           { 'ghi' }
    let(:now_in_stats)   { 1 }
    let(:players)        { nil }
    let(:quantity)       { 7 }
    let(:types)          { ['jkl','mno'] }
    let(:xml_string) { "
      <plays>
        <play date='#{date.to_s}'
              quantity='#{quantity}'
              length='#{length}'
              incomplete='#{incomplete}'
              nowinstats='#{now_in_stats}'
              location='#{location}'>
          <item name='#{name}' objectid='#{id}'>
            <subtypes>
              <subtype value='#{types.first}'/>
              <subtype value='#{types.last}'/>
            </subtypes>
          </item>
          <comments>#{comment}</comments>
          <players>
            #{players}
          </players>
        </play>
      </plays>" }

    its(:comment)        { should eq comment }
    its(:date)           { should eq date }
    its(:id)             { should eq id }
    its(:incomplete?)    { should eq false }
    its(:length)         { should eq length }
    its(:location)       { should eq location }
    its(:name)           { should eq name }
    its(:now_in_stats?)  { should eq true }
    its(:quantity)       { should eq quantity }
    its(:type)           { should eq types.first }
    its(:types)          { should eq types }

    context 'no winner' do
      let(:players) { '<player username="a" name="A" win="0"/>' }

      it { expect( subject.first ).to be_instance_of subject.class::Player }
      its(:count) { should eq 1 }
      it { expect( subject.players.count ).to eq 1 }
      its(:winner)         { should eq nil }
    end
    context 'winner with username' do
      let(:players) { '<player username="a" name="A" win="1"/>' }

      it { expect( subject.first ).to be_instance_of subject.class::Player }
      its(:count) { should eq 1 }
      it { expect( subject.players.count ).to eq 1 }
      its(:winner)         { should eq 'a' }
    end
    context 'winner with name' do
      let(:players) { '<player username="" name="A" win="0"/>
                       <player username="" name="B" win="1"/>'}

      it { expect( subject.first ).to be_instance_of subject.class::Player }
      its(:count) { should eq 2 }
      it { expect( subject.players.count ).to eq 2 }
      its(:winner)         { should eq 'B' }
    end

    describe Bgg::Result::Plays::Play::Player do
      let(:players) { '<player username="a"
                               userid="1234"
                               name="A"
                               startposition="x"
                               color="y"
                               score="100"
                               new="1"
                               rating="5.5"
                               win="0"/>' }
      subject { Bgg::Result::Plays::Play::Player.new(item_xml.at_xpath('plays/play/players/player'), request) }

      its(:color)          { should eq 'y' }
      its(:id)             { should eq 1234 }
      its(:name)           { should eq 'A' }
      its(:new?)           { should eq true }
      its(:rating)         { should eq 5.5 }
      its(:score)          { should eq 100 }
      its(:start_position) { should eq 'x' }
      its(:username)       { should eq 'a' }
      its(:winner?)        { should eq false }
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
    let(:response_file)  { 'sample_data/plays.xml' }
    let(:xml_string)     { File.open(response_file) }

    its(:comment)        { should_not eq nil }
    its(:date)           { should_not eq nil }
    its(:id)             { should_not eq nil }
    its(:incomplete?)    { should_not eq nil }
    its(:length)         { should_not eq nil }
    its(:location)       { should_not eq nil }
    its(:name)           { should_not eq nil }
    its(:now_in_stats?)  { should_not eq nil }
    its(:players)        { should_not eq nil }
    its(:quantity)       { should_not eq nil }
    its(:type)           { should_not eq nil }
    its(:types)          { should_not eq nil }
    its(:winner)         { should_not eq nil }

    describe Bgg::Result::Plays::Play::Player do
      subject { Bgg::Result::Plays::Play::Player.new(item_xml.at_xpath('plays/play/players/player'), request) }

      its(:color)          { should_not eq nil }
      its(:id)             { should_not eq nil }
      its(:name)           { should_not eq nil }
      its(:new?)           { should_not eq nil }
      its(:rating)         { should_not eq nil }
      its(:score)          { should_not eq nil }
      its(:start_position) { should_not eq nil }
      its(:username)       { should_not eq nil }
      its(:winner?)        { should_not eq nil }
    end
  end
end

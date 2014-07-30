require 'spec_helper'

describe Bgg::Request::Hot do
  let(:with) { {} }
  let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/hot' }
  let(:response_body) { '<?xml version="1.0" encoding="utf-8"?><items><item/><items>' }

  before do
    stub_request(:any, request_url).
      with( { query:  with } ).
      to_return(body: response_body, status:200)
  end

  it { expect( subject ).to be_a Bgg::Request::Base }

  context 'class methods' do

    def class_method_helper
      expect( subject ).to be_instance_of Bgg::Request::Hot
      expect( subject.get ).to be_instance_of Bgg::Result::Hot
    end

    describe '.board_game_companies' do
      let(:with) { { type: 'boardgamecompany' } }

      subject { Bgg::Request::Hot.board_game_companies }

      it { class_method_helper }
    end

    describe '.board_game_people' do
      let(:with) { { type: 'boardgameperson' } }

      subject { Bgg::Request::Hot.board_game_people }

      it { class_method_helper }
    end

    describe '.board_games' do
      let(:with) { { type: 'boardgame' } }

      subject { Bgg::Request::Hot.board_games }

      it { class_method_helper }
    end

    describe '.rpg_companies' do
      let(:with) { { type: 'rpgcompany' } }

      subject { Bgg::Request::Hot.rpg_companies }

      it { class_method_helper }
    end

    describe '.rpg_people' do
      let(:with) { { type: 'rpgperson' } }

      subject { Bgg::Request::Hot.rpg_people }

      it { class_method_helper }
    end

    describe '.rpgs' do
      let(:with) { { type: 'rpg' } }

      subject { Bgg::Request::Hot.rpgs }

      it { class_method_helper }
    end

    describe '.video_game_companies' do
      let(:with) { { type: 'videogamecompany' } }

      subject { Bgg::Request::Hot.video_game_companies }

      it { class_method_helper }
    end

    describe '.video_games' do
      let(:with) { { type: 'videogame' } }

      subject { Bgg::Request::Hot.video_games }

      it { class_method_helper }
    end
  end

  context 'create instance' do

    context 'with no params' do
      subject { Bgg::Request::Hot.new }

      it { should be_instance_of Bgg::Request::Hot }
      its(:get) { should be_instance_of Bgg::Result::Hot }
    end

    context 'with params' do
      let(:type) { 'abc' }
      let(:with) { { type: type } }

      subject { Bgg::Request::Hot.new( { type: type } ) }

      it { should be_instance_of Bgg::Request::Hot }
      its(:get) { should be_instance_of Bgg::Result::Hot }
    end
  end
end

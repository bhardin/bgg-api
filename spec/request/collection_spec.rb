require 'spec_helper'

describe Bgg::Request::Collection do
  let(:query) { { username: username } }
  let(:response_body) { '<?xml version="1.0" encoding="utf-8"?><items><item/><items>' }
  let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/collection' }
  let(:username) { 'abcdef' }

  subject { Bgg::Request::Collection.new username }

  before do
    stub_request(:any, request_url).
      with(query: query).
      to_return(body: response_body, status:200)
  end

  context 'throws an ArgumentError when username not present' do
    it do
      expect{ Bgg::Request::Collection.new nil }.to raise_error ArgumentError
      expect{ Bgg::Request::Collection.new '' }.to raise_error ArgumentError
    end
  end

  context 'class methods' do

    def class_method_helper
      expect( subject ).to be_instance_of Bgg::Request::Collection
      expect( subject.get ).to be_instance_of Bgg::Result::Collection
    end

    describe '.board_games' do
      let(:query) { { username: username, subtype: 'boardgame', excludesubtype: 'boardgameexpansion' } }

      subject { Bgg::Request::Collection.board_games username }

      it { class_method_helper }
    end

    describe '.board_game_expansions' do
      let(:query) { { username: username, subtype: 'boardgameexpansion' } }

      subject { Bgg::Request::Collection.board_game_expansions username }

      it { class_method_helper }
    end

    describe '.rpgs' do
      let(:query) { { username: username, subtype: 'rpgitem' } }

      subject { Bgg::Request::Collection.rpgs username }

      it { class_method_helper }
    end

    describe '.video_games' do
      let(:query) { { username: username, subtype: 'videogame' } }

      subject { Bgg::Request::Collection.video_games username }

      it { class_method_helper }
    end
  end

  describe '#all_fields' do
    let(:query) { { username: username, version: 1, stats: 1, showprivate: 1 } }

    it do
      expect( subject.all_fields ).to be_instance_of Bgg::Request::Collection
      expect( subject.all_fields.get ).to be_instance_of Bgg::Result::Collection
    end
  end

  describe '#brief' do
    let(:query) { { username: username, brief: 1 } }

    it do
      expect( subject.brief ).to be_instance_of Bgg::Request::Collection
      expect( subject.brief.get ).to be_instance_of Bgg::Result::Collection
    end
  end
end

require 'spec_helper'

describe Bgg::Request::Search do
  let(:with) { { query: { query: query  } } }
  let(:query) { 'abc' }
  let(:request_url) { "http://www.boardgamegeek.com/xmlapi2/search" }
  let(:response_body) { '<?xml version="1.0" encoding="utf-8"?><items><item/><items>' }

  subject { Bgg::Request::Search.new query }

  before do
    stub_request(:any, request_url).
      with(with).
      to_return(body: response_body, status:200)
  end

  it { expect( subject ).to be_a Bgg::Request::Base }

  context 'throws an ArgumentError when query not present' do
    it do
      expect{ Bgg::Request::Search.new nil }.to raise_error ArgumentError
      expect{ Bgg::Request::Search.new '' }.to raise_error ArgumentError
    end
  end

  context 'class methods' do

    def class_method_helper
      expect( subject ).to be_instance_of Bgg::Request::Search
      expect( subject.get ).to be_instance_of Bgg::Result::Search
    end

    describe ".board_games" do
      let(:with) { { query: { query: query, type: "boardgame" } } }

      subject { Bgg::Request::Search.board_games query }

      it { class_method_helper }
    end

    describe ".board_game_expansions" do
      let(:with) { { query: { query: query, type: "boardgameexpansion" } } }

      subject { Bgg::Request::Search.board_game_expansions query }

      it { class_method_helper }
    end

    describe ".rpg_issues" do
      let(:with) { { query: { query: query, type: "rpgissue" } } }

      subject { Bgg::Request::Search.rpg_issues query }

      it { class_method_helper }
    end

    describe ".rpg_items" do
      let(:with) { { query: { query: query, type: "rpgitem" } } }

      subject { Bgg::Request::Search.rpg_items query }

      it { class_method_helper }
    end

    describe ".rpg_periodicals" do
      let(:with) { { query: { query: query, type: "rpgperiodical" } } }

      subject { Bgg::Request::Search.rpg_periodicals query }

      it { class_method_helper }
    end

    describe ".rpgs" do
      let(:with) { { query: { query: query, type: "rpg" } } }

      subject { Bgg::Request::Search.rpgs query }

      it { class_method_helper }
    end

    describe ".video_games" do
      let(:with) { { query: { query: query, type: "videogame" } } }

      subject { Bgg::Request::Search.video_games query }

      it { class_method_helper }
    end
  end

  describe "#exact" do
    let(:with) { { query: { query: query, exact: 1 } } }

    it do
      expect( subject.exact ).to be_instance_of Bgg::Request::Search
      expect( subject.exact.get ).to be_instance_of Bgg::Result::Search
    end
  end
end

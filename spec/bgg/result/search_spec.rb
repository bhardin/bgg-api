require 'spec_helper'

describe Bgg::Result::Search do
  let(:item1_data) { nil }
  let(:item1_type) { 'boardgame' }
  let(:item2_data) { nil }
  let(:item2_type) { 'rpgitem' }
  let(:item3) { nil }
  let(:request) { double('Bgg::Request::Search') }
  let(:xml_string) { "
    <items>
      <item type='#{item1_type}' id='1'>#{item1_data}</item>
      <item type='#{item2_type}' id='2'>#{item2_data}</item>
      #{item3}
    </items>" }
  subject { Bgg::Result::Search.new(Nokogiri.XML(xml_string), request) }

  before do
    request.stub(:params).and_return( { query: 'query' } )
  end

  it { expect( subject ).to be_a Bgg::Result::Enumerable }

  describe 'types' do
    describe '#board_games' do
      let(:item1_type) { 'boardgame' }
      let(:item2_type) { 'bogus' }

      it { expect( subject.board_games.count ).to eq 1 }
    end

    describe '#board_game_expansions' do
      let(:item1_type) { 'boardgameexpansion' }
      let(:item2_type) { 'bogus' }

      it { expect( subject.board_game_expansions.count ).to eq 1 }
    end

    describe '#rpg_issues' do
      let(:item1_type) { 'rpgissue' }
      let(:item2_type) { 'bogus' }

      it { expect( subject.rpg_issues.count ).to eq 1 }
    end

    describe '#rpg_items' do
      let(:item1_type) { 'rpgitem' }
      let(:item2_type) { 'bogus' }

      it { expect( subject.rpg_items.count ).to eq 1 }
    end

    describe '#rpg_periodicals' do
      let(:item1_type) { 'rpgperiodical' }
      let(:item2_type) { 'bogus' }

      it { expect( subject.rpg_periodicals.count ).to eq 1 }
    end

    describe '#rpgs' do
      let(:item1_type) { 'rpg' }
      let(:item2_type) { 'bogus' }

      it { expect( subject.rpgs.count ).to eq 1 }
    end

    describe '#video_games' do
      let(:item1_type) { 'videogame' }
      let(:item2_type) { 'bogus' }

      it { expect( subject.video_games.count ).to eq 1 }
    end
  end
end

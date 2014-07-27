require 'spec_helper'

describe Bgg::Request::Plays do
  let(:query) { {} }
  let(:response_body) { '<?xml version="1.0" encoding="utf-8"?><plays><play/><plays>' }
  let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/plays' }

  before do
    stub_request(:any, request_url).
      with(query: query).
      to_return(body: response_body, status:200)
  end

  def request_test_helper
    expect( subject ).to be_instance_of Bgg::Request::Plays
    expect( subject.get ).to be_instance_of Bgg::Result::Plays
  end

  context 'instance' do
    let(:username) { nil }
    let(:thing_id) { nil }

    subject { Bgg::Request::Plays.new username, thing_id }

    context 'throws an ArgumentError when neither username nor thing_id are present' do
      it do
        expect{ Bgg::Request::Plays.new nil, nil }.to raise_error ArgumentError
        expect{ Bgg::Request::Plays.new '', '' }.to raise_error ArgumentError
      end
    end

    context 'username request' do
      let(:query) { { username: username } }
      let(:username) { 'abcdef' }

      it { expect( subject ).to be_instance_of Bgg::Request::Plays }

      describe '#date' do
        context 'single' do
          let(:date) { Date.new(2000, 1, 1) }
          let(:query) { { username: username, mindate: date.to_s, maxdate: date.to_s } }

          it do
            expect( subject.date(date) ).to be_instance_of Bgg::Request::Plays
            expect( subject.date(date).get ).to be_instance_of Bgg::Result::Plays
          end
        end

        context 'range' do
          let(:min_date) { Date.new(2000, 1, 1) }
          let(:max_date) { Date.new(2001, 1, 1) }
          let(:date_range) { min_date..max_date }
          let(:query) { { username: username, mindate: min_date.to_s, maxdate: max_date.to_s } }

          it do
            expect( subject.date(date_range) ).to be_instance_of Bgg::Request::Plays
            expect( subject.date(date_range).get ).to be_instance_of Bgg::Result::Plays
          end
        end
      end

      describe '#page' do
        let(:query) { { username: username, page: 2 } }

        it do
          expect( subject.page(2) ).to be_instance_of Bgg::Request::Plays
          expect( subject.page(2).get ).to be_instance_of Bgg::Result::Plays
        end
      end
    end

    context 'thing request' do
      let(:query) { { id: thing_id } }
      let(:thing_id) { 1234 }

      it { request_test_helper }
    end

    context 'username and thing request' do
      let(:query) { { username: username, id: thing_id } }
      let(:thing_id) { 1234 }
      let(:username) { 'abcdef' }

      it { request_test_helper }
    end

  end

  context 'class methods' do
    let(:thing_id) { 1234 }
    let(:username) { 'abcdef' }

    describe '.board_game_expansions' do
      let(:query) { { username: username, id: thing_id, subtype: 'boardgameexpansion' } }

      subject { Bgg::Request::Plays.board_game_expansions username, thing_id }

      it { request_test_helper }
    end

    describe '.board_game_implementations' do
      let(:query) { { username: username, id: thing_id, subtype: 'boardgameimplementation' } }

      subject { Bgg::Request::Plays.board_game_implementations username, thing_id }

      it { request_test_helper }
    end

    describe '.board_games' do
      let(:query) { { username: username, id: thing_id, subtype: 'boardgame' } }

      subject { Bgg::Request::Plays.board_games username, thing_id }

      it { request_test_helper }
    end

    describe '.rpgs' do
      let(:query) { { username: username, id: thing_id, subtype: 'rpgitem' } }

      subject { Bgg::Request::Plays.rpgs username, thing_id }

      it { request_test_helper }
    end

    describe '.video_games' do
      let(:query) { { username: username, id: thing_id, subtype: 'videogame' } }
      subject { Bgg::Request::Plays.video_games username, thing_id }

      it { request_test_helper }
    end
  end
end

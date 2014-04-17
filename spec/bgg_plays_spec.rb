# encoding: UTF-8
require 'spec_helper'

describe Bgg::Plays do
  describe 'class method' do
    describe 'find_by_username' do
      it 'throws an ArgumentError when a number is passed in' do
        expect{ Bgg::Collection.find_by_username(38383) }.to raise_error(ArgumentError)
      end

      it 'throws an ArgumentError when an empty string is passed in' do
        expect{ Bgg::Collection.find_by_username('') }.to raise_error(ArgumentError)
      end

      it 'throws an ArgumentError when a string of only numbers is passed in' do
        expect{ Bgg::Collection.find_by_username('38383') }.to raise_error(ArgumentError)
      end

      it 'throws an ArgumentError when a non-existent user is passed in' do
        response_file = 'sample_data/plays?username=yyyyyyy&page=1'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/plays'

        stub_request(:any, request_url).
          with(query: {username: 'yyyyyyy', page: 1}).
          to_return(body: File.open(response_file), status: 200)

        expect{ Bgg::Plays.find_by_username('yyyyyyy') }.to raise_error(ArgumentError)
      end

      it 'returns an empty iterator when a valid user has no plays' do
        response_file = 'sample_data/plays?username=beetss&page=1'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/plays'

        stub_request(:any, request_url).
          with(query: {username: 'beetss', page: 1}).
          to_return(body: File.open(response_file), status: 200)

        iterator = Bgg::Plays.find_by_username('beetss')
        expect( iterator ).to be_an_instance_of(Bgg::Plays::Iterator)
        expect( iterator.empty? ).to eq(true)
      end

      it 'creates a Bgg::Plays::Iterator object for a user who has plays' do
        response_file = 'sample_data/plays?username=texasjdl&page=1'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/plays'

        stub_request(:any, request_url).
          with(query: {username: 'texasjdl', page: 1}).
          to_return(body: File.open(response_file), status: 200)

        plays = Bgg::Plays.find_by_username('texasjdl')
        first_play = plays.first

        expect( plays ).to be_a_kind_of(Bgg::Plays::Iterator)
        expect( first_play ).to be_instance_of(Bgg::Play)
        expect( first_play.players ).to be_instance_of(Array)
      end
    end
  end
end

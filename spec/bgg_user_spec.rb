require 'spec_helper'

describe Bgg::User do
  describe 'class method' do
    describe 'find_by_id' do
      it 'throws an ArgumentError when a non-integer is passed in' do
        expect{ Bgg::User.find_by_id('string instead') }.to raise_error(ArgumentError)
      end

      it 'throws an ArgumentError when a non-positive integer is passed in' do
        expect{ Bgg::User.find_by_id(0) }.to  raise_error(ArgumentError)
        expect{ Bgg::User.find_by_id(-1) }.to raise_error(ArgumentError)
      end

      it 'creates an object for a user who exists' do
        response_file = 'sample_data/user?name=texasjdl'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/user'

        stub_request(:any, request_url).with(query: {id: 39488}).to_return(body: File.open(response_file), status: 200)
        texasjdl = Bgg::User.find_by_id(39488)

        expect( texasjdl ).to be_a_kind_of(Bgg::User)
        expect( texasjdl.name ).to eq('texasjdl')
      end

      it 'throws an ArgumentError for a user who does not exist' do
        response_file = 'sample_data/user?name=yyyyyyy'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/user'

        stub_request(:any, request_url).with(query: {id: 39488}).to_return(body: File.open(response_file), status: 200)

        expect{ Bgg::User.find_by_id(39488) }.to raise_error(ArgumentError, 'User does not exist')
      end
    end

    describe 'find_by_name' do
      it 'creates an object for a user who exists' do
        response_file = 'sample_data/user?name=texasjdl'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/user'

        stub_request(:any, request_url).with(query: {name: 'texasjdl'}).to_return(body: File.open(response_file), status: 200)
        texasjdl = Bgg::User.find_by_name('texasjdl')

        expect( texasjdl ).to be_a_kind_of(Object)
        expect( texasjdl.name ).to eq('texasjdl')
      end

      it 'throws an ArgumentError when being passed a number' do
        expect{ Bgg::User.find_by_name(111) }.to raise_error(ArgumentError, 'find_by_name must be passed a string!')
      end

      it 'throws an ArgumentError for a user who does not exist' do
        response_file = 'sample_data/user?name=yyyyyyy'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/user'

        stub_request(:any, request_url).with(query: {name: 'yyyyyyy'}).to_return(body: File.open(response_file), status: 200)

        expect{ Bgg::User.find_by_name('yyyyyyy') }.to raise_error(ArgumentError, 'User does not exist')
      end
    end

    describe 'instance method' do
      let(:response_file) { 'sample_data/user?name=texasjdl' }
      let(:request_url)   { 'http://www.boardgamegeek.com/xmlapi2/user' }
      let(:texasjdl)      { Bgg::User.find_by_id(39488) }

      before do
        stub_request(:any, request_url).
          with(query: {id: 39488}).
          to_return(body: File.open(response_file), status: 200)
      end

      describe '.play_count' do
        it 'returns the number of plays when the user has plays' do
          stub_request(:any, 'http://www.boardgamegeek.com/xmlapi2/plays').
            with(query: {username: 'texasjdl', page: 1}).
            to_return(body: File.open('sample_data/plays?username=texasjdl&page=1'), status: 200)

          expect( texasjdl.play_count ).to eq(299)
        end
      end

      describe 'collection' do
        it 'returns the collection object representing the collection for the user' do
          stub_request(:any, 'http://www.boardgamegeek.com/xmlapi2/collection').
            with(query: {username: 'texasjdl'}).
            to_return(body: '<?xml version="1.0" encoding="utf-8"?><items><item/><items>',status: 200)

          collection = texasjdl.collection

          expect( collection ).to be_instance_of(Bgg::Result::Collection)
          expect( collection.first ).to be_instance_of(Bgg::Result::Collection::Item)
        end
      end

      describe '.plays' do
        it 'returns a Bgg::PlaysIterator' do
          [1,2,3].each do |i|
            stub_request(:any, 'http://www.boardgamegeek.com/xmlapi2/plays').
              with(query: {username: 'texasjdl', page: i}).
              to_return(body: File.open("sample_data/plays?username=texasjdl&page=#{i}"), status: 200)
          end

          plays = texasjdl.plays
          first_play = plays.first

          expect( plays ).to be_an_instance_of(Bgg::Plays::Iterator)
          expect( first_play ).to be_an_instance_of(Bgg::Play)
          expect( first_play.game_name ).to eq('Fauna')
          expect( first_play.players.size ).to eq(5)
          expect( first_play.players.first.name ).to eq('Ted')
        end
      end
    end
  end
end

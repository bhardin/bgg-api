require 'spec_helper'

describe BggUser do
  describe 'class method' do
    describe 'find_by_id' do
      it 'throws an ArgumentError when a non-integer is passed in' do
        expect{ BggUser.find_by_id('string instead') }.to raise_error(ArgumentError)
      end

      it 'throws an ArgumentError when a non-positive integer is passed in' do
        expect{ BggUser.find_by_id(0) }.to  raise_error(ArgumentError)
        expect{ BggUser.find_by_id(-1) }.to raise_error(ArgumentError)
      end

      it 'creates an object for a user who exists' do
        response_file = 'sample_data/user?name=texasjdl'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/user'

        stub_request(:any, request_url).with(query: {id: 39488}).to_return(body: File.open(response_file), status: 200)
        texasjdl = BggUser.find_by_id(39488)

        expect( texasjdl ).to be_a_kind_of(Object)
        expect( texasjdl.name ).to eq('texasjdl')
      end

      it 'throws an ArgumentError for a user who does not exist' do
        response_file = 'sample_data/user?name=yyyyyyy'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/user'

        stub_request(:any, request_url).with(query: {id: 39488}).to_return(body: File.open(response_file), status: 200)

        expect{ BggUser.find_by_id(39488) }.to raise_error(ArgumentError, 'User does not exist')
      end
    end

    describe 'find_by_name' do
      it 'creates an object for a user who exists' do
        response_file = 'sample_data/user?name=texasjdl'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/user'

        stub_request(:any, request_url).with(query: {name: 'texasjdl'}).to_return(body: File.open(response_file), status: 200)
        texasjdl = BggUser.find_by_name('texasjdl')

        expect( texasjdl ).to be_a_kind_of(Object)
        expect( texasjdl.name ).to eq('texasjdl')
      end

      it 'throws an ArgumentError for a user who does not exist' do
        response_file = 'sample_data/user?name=yyyyyyy'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/user'

        stub_request(:any, request_url).with(query: {name: 'yyyyyyy'}).to_return(body: File.open(response_file), status: 200)

        expect{ BggUser.find_by_name('yyyyyyy') }.to raise_error(ArgumentError, 'User does not exist')
      end
    end

    describe 'instance method' do
      let(:response_file) { 'sample_data/user?name=texasjdl' }
      let(:request_url)   { 'http://www.boardgamegeek.com/xmlapi2/user' }
      let(:texasjdl)      { BggUser.find_by_id(39488) }

      before do
        stub_request(:any, request_url).
          with(query: {id: 39488}).
          to_return(body: File.open(response_file), status: 200)
      end

      describe '.play_count' do
        it 'returns the number of plays when the user has plays' do
          stub_request(:any, 'http://www.boardgamegeek.com/xmlapi2/plays').
            with(query: {username: 'texasjdl', page: 1}).
            to_return(body: File.open('sample_data/plays?page=1&username=texasjdl'), status: 200)

          expect( texasjdl.play_count ).to eq(2467)
        end
      end

      describe 'collection' do
        it 'returns the collection object representing the collection for the user' do
          stub_request(:any, 'http://www.boardgamegeek.com/xmlapi2/collection').
            with(query: {username: 'texasjdl'}).
            to_return(body: File.open('sample_data/collection?username=texasjdl'), status: 200)

          collection = texasjdl.collection

          expect( collection ).to be_instance_of(BggCollection)
          expect( collection.owned.first ).to be_instance_of(BggCollectionItem)
          expect( collection.size ).to eq(604)
        end
      end
    end
  end
end

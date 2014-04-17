# encoding: UTF-8
require 'spec_helper'

describe Bgg::Collection do
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
      response_file = 'sample_data/collection?username=yyyyyyy'
      request_url = 'http://www.boardgamegeek.com/xmlapi2/collection'

      stub_request(:any, request_url).
        with(query: {username: 'yyyyyyy'}).
        to_return(body: File.open(response_file), status: 200)

      expect{ Bgg::Collection.find_by_username('yyyyyyy')}.to raise_error(ArgumentError)
    end

    it 'creates an object for a collection that exists' do
      response_file = 'sample_data/collection?username=texasjdl'
      request_url = 'http://www.boardgamegeek.com/xmlapi2/collection'

      stub_request(:any, request_url).
        with(query: {username: 'texasjdl'}).
        to_return(body: File.open(response_file), status: 200)

      collection = Bgg::Collection.find_by_username('texasjdl')

      expect( collection ).to be_a_kind_of(Bgg::Collection)
      expect( collection.owned.first ).to be_instance_of(Bgg::Collection::Item)
      expect( collection.owned.first.name ).to eq('& Cetera')
    end
  end

  describe 'instance' do
    let(:collection) { Bgg::Collection.find_by_username('texasjdl') }

    before do
      response_file = 'sample_data/collection?username=texasjdl'
      request_url = 'http://www.boardgamegeek.com/xmlapi2/collection'

      stub_request(:any, request_url).
        with(query: {username: 'texasjdl'}).
        to_return(body: File.open(response_file), status: 200)
    end

    it 'has boardgames' do
      expect( collection.boardgames ).to be_instance_of(Array)
      expect( collection.boardgames.first ).to be_instance_of(Bgg::Collection::Item)
      expect( collection.boardgames.count).to eq(604)
    end

    it 'has boardgame_expansions' do
      expect( collection.boardgame_expansions ).to be_instance_of(Array)
      expect( collection.boardgame_expansions.first ).to be_instance_of(Bgg::Collection::Item)
      expect( collection.boardgame_expansions.count).to eq(37)
    end

    it 'has played' do
      expect( collection.played ).to be_instance_of(Array)
      expect( collection.played.first ).to be_instance_of(Bgg::Collection::Item)
      expect( collection.played.count).to eq(365)
    end

    it 'has size' do
      expect( collection.size ).to eq(604)
    end

    it 'has count' do
      expect( collection.count ).to eq(604)
    end
  end

end

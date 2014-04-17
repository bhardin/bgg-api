# encoding: UTF-8
require 'spec_helper'

describe Bgg::Search do
  describe 'class method' do
    describe 'query' do
      it 'throws an ArgumentError when an empty string is passed in' do
        expect{ Bgg::Search.query('') }.to raise_error(ArgumentError)
      end

      it 'throws an ArgumentError when a non-string is passed in' do
        expect{ Bgg::Search.query(Object.new) }.to raise_error(ArgumentError)
      end

      it 'returns an empty array when a search has no results' do
        response_file = 'sample_data/search?query=yyyyyyy'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/search'

        stub_request(:any, request_url).
          with(query: {query: 'yyyyyyy'}).
          to_return(body: File.open(response_file), status: 200)

        search_results = Bgg::Search.query('yyyyyyy')

        expect( search_results      ).to be_instance_of(Array)
        expect( search_results.size ).to eq(0)
      end

      it 'creates an object for a collection that exists' do
        response_file = 'sample_data/search?query=Burgun'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/search'

        stub_request(:any, request_url).
          with(query: {query: 'Burgun'}).
          to_return(body: File.open(response_file), status: 200)

        search_results = Bgg::Search.query('Burgun')

        expect( search_results      ).to be_instance_of(Array)
        expect( search_results.size ).to eq(11)

        expect( search_results.first      ).to be_instance_of(Bgg::Search::Result)
        expect( search_results.first.name ).to eq('The Castles of Burgundy')
      end
    end

    describe 'exact_query' do
      it 'throws an ArgumentError when an empty string is passed in' do
        expect{ Bgg::Search.exact_query('') }.to raise_error(ArgumentError)
      end

      it 'throws an ArgumentError when a non-string is passed in' do
        expect{ Bgg::Search.exact_query(Object.new) }.to raise_error(ArgumentError)
      end

      it 'returns nil when a search has no results' do
        response_file = 'sample_data/search?query=Burgun&exact=1'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/search'

        stub_request(:any, request_url).
          with(query: {query: 'Burgun', exact: 1}).
          to_return(body: File.open(response_file), status: 200)

        search_results = Bgg::Search.exact_query('Burgun')

        expect( search_results ).to eq(nil)
      end

      it 'returns a single result for a result that exists' do
        response_file = 'sample_data/search?query=The+Castles+of+Burgundy&exact=1'
        request_url = 'http://www.boardgamegeek.com/xmlapi2/search'

        stub_request(:any, request_url).
          with(query: {query: 'The Castles of Burgundy', exact: 1}).
          to_return(body: File.open(response_file), status: 200)

        search_result = Bgg::Search.exact_query('The Castles of Burgundy')

        expect( search_result      ).to be_instance_of(Bgg::Search::Result)
        expect( search_result.name ).to eq('The Castles of Burgundy')
      end
    end
  end
end

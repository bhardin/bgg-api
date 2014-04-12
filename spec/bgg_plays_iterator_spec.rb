# encoding: UTF-8
require 'spec_helper'

describe BggPlaysIterator do
  describe 'instance' do
    let(:username) { 'texasjdl' }
    let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/plays' }
    let(:query) { {username: username, page: 1} }
    let(:response_file) { "sample_data/plays?username=#{username}&page=1" }
    let(:iterator) { BggPlaysIterator.new(username) }

    before do
      stub_request(:any, request_url).
        with(query: query).
        to_return(body: File.open(response_file), status: 200)
    end

    it 'is Enumerable' do
      expect( iterator ).to be_a_kind_of(Enumerable)
    end

    context 'when the user has no plays' do
      let(:username) { 'beetss' }
      it 'returns an empty iterator' do
        expect( iterator.empty? ).to eq(true)
      end
    end

    context 'when the user does not exist' do
      let(:username) { 'yyyyyyy' }
      it 'returns an empty iterator' do
        expect{ iterator }.to raise_error(ArgumentError, 'user does not exist')
      end
    end

    context 'when the user exists and has plays' do
      it 'returns an instance' do
        expect( iterator ).to be_instance_of(BggPlaysIterator)
      end
    end

    describe '.each' do
      it 'exists' do
        expect( iterator ).to respond_to(:each)
      end

      it 'allows stepping through results' do
        iterator.each do |item|
          expect( item ).to be_instance_of(BggPlay)
          break if iterator.iteration == 3
        end
      end

      it 'only allows stepping through the results once' do
        iterator.each { break if iterator.iteration == 2 }
        iterator.each { fail }
      end

      it 'returns multiple pages of results' do
        [2,3].each do |i|
          stub_request(:any, request_url).
            with(query: {username: username, page: i}).
            to_return(body: File.open("sample_data/plays?username=#{username}&page=#{i}"),
                      status: 200)
        end

        iterator.each { }
        expect( iterator.iteration ).to eq(299)
      end
    end

    describe '.iteration' do
      it 'exists' do
        expect( iterator ).to respond_to(:iteration)
      end

      it 'returns the maximum value when the iterator is exhausted' do
        count = 0
        iterator.each do |item|
          count += 1
          expect( iterator.iteration ).to eq(count)
          break if iterator.iteration == 3
        end
      end

      it 'returns the current iteration through the block' do
        count = 0
        iterator.each do |item|
          count += 1
          expect( iterator.iteration ).to eq(count)
          break if iterator.iteration == 3
        end
      end

      context 'when the iterator starts empty,' do
        let(:username) { 'beetss' }
        it 'returns 0' do
          expect( iterator.iteration ).to eq(0)
        end
      end
    end

    describe '.empty?' do
      it 'exists' do
        expect( iterator ).to respond_to(:empty?)
      end

      context 'when the iterator has no results' do
        let(:username) { 'beetss' }
        it 'returns true' do
          expect( iterator.empty? ).to eq(true)
        end
      end

      context 'when the iterator has results' do
        it 'returns false' do
          expect( iterator.empty? ).to eq(false)
        end
      end

      context 'when the iterator has paged through results' do
        it 'returns true if each() has already reached the end' do
          [2,3].each do |i|
            stub_request(:any, request_url).
              with(query: {username: username, page: i}).
              to_return(body: File.open("sample_data/plays?username=#{username}&page=#{i}"),
                        status: 200)
          end

          iterator.each{ }
          expect( iterator.empty? ).to eq(true)
        end
      end
    end

    describe '.total_count' do
      it 'exists' do
        expect( iterator ).to respond_to(:total_count)
      end

      context 'when the user has no plays' do
        let(:username) { 'beetss' }
        it 'returns 0' do
          expect( iterator.total_count ).to eq(0)
        end
      end

      context 'when the user has plays' do
        let(:username) { 'texasjdl' }
        it 'returns the correct count' do
          expect( iterator.total_count ).to eq(299)
        end
      end
    end
  end
end

# encoding: UTF-8
require 'spec_helper'

describe 'BggApi richer API call' do
  describe 'entire_user_plays' do
    it 'returns the play history for a user' do
      query = 'http://www.boardgamegeek.com/xmlapi2/plays?page=1&username=ryanmacg'
      response_data = File.new('sample_data/plays?username=ryanmacg')

      stub_request(:get, query).to_return(body: response_data, status: 200)

      results = BggApi.entire_user_plays('ryanmacg')
      results.count != 0
    end

    it 'does not return results for pages that have no plays' do
      query = 'http://www.boardgamegeek.com/xmlapi2/plays?page=9999999999999&username=ryanmacg'
      response_data = File.new('sample_data/plays?pages=9999999999999&username=ryanmacg')

      stub_request(:get, query).to_return(body: response_data, status: 500)

      results = BggApi.entire_user_plays('ryanmacg', 9999999999999)
      results.should be_nil
    end
  end
end

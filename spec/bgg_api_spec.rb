require 'spec_helper'

describe BggApi do
  let(:bgg) { BggApi.new }

  context 'with stubbed responses' do

    let(:expected_response) { File.open(response_file) }

    before do
      stub_request(:any, request_url)
        .with(:query => query)
        .to_return(:body => expected_response, :status => 200)
    end

    describe 'BGG Search' do
      let(:query) { {:query => 'Burgund', :type => 'boardgame'} }
      let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/search' }
      let(:response_file) { 'sample_data/search?query=Burgund&type=boardgame' }

      subject(:results) { bgg.search(query) }

      it { should_not be_nil }
    end

    describe 'BGG Thing' do
      let(:query) { {:id => '84876', :type => 'boardgame'} }
      let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/thing' }
      let(:response_file) { 'sample_data/thing?id=84876&type=boardgame' }

      subject(:results) { bgg.thing(query) }

      it { should_not be_nil }

      it 'retrieves the correct id' do
        results['item'][0]['id'].should == '84876'
      end
    end

    describe 'BGG Collection' do
      let(:query) { {:own => '1', :username => 'texasjdl', :type => 'boardgame'} }
      let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/collection' }
      let(:response_file) { 'sample_data/collection?username=texasjdl&own=1&excludesubtype=boardgameexpansion' }

      subject(:results) { bgg.collection(query) }

      it { should_not be_nil }

      it 'retrieves the correct id' do
        results['item'][0]['objectid'].should == '421'
      end
    end

    describe 'BGG Hot Items' do
      let(:query) { {:type => 'boardgame'} }
      let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/hot' }
      let(:response_file) { 'sample_data/hot?type=boardgame' }

      subject(:results) { bgg.hot(query) }

      it { should_not be_nil }

      it 'retrieves the correct rank' do
        results['item'][0]['rank'].should == '1'
      end
    end

    describe 'BGG Plays' do
      let(:query) { {:id => '84876', :username => 'texasjdl'} }
      let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/plays' }
      let(:response_file) { 'sample_data/plays?username=texasjdl&id=84876' }

      subject(:results) { bgg.plays(query) }

      it { should_not be_nil }

      it 'retrieves the correct total' do
        results['total'].should == '27'
      end
    end
  end
end
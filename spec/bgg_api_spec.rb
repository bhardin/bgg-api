require 'spec_helper'

describe 'BggApi basic API calls' do
  context 'when calling an undefined method' do
    subject { BggApi.foo }

    it 'raises an UndefinedMethodError' do
      expect { subject }.to raise_error(NoMethodError)
    end
  end

  context 'when non-200 responses' do
    let(:expected_response) { File.open(response_file) }
    let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/search' }
    let(:response_file) { 'sample_data/search?query=Burgund&type=boardgame' }

    before do
      stub_request(:any, request_url)
        .with(query: query)
        .to_return(body: expected_response, status: 500)
    end

    describe 'BGG Search' do
      let(:query) { {query: 'Burgund', type: 'boardgame'} }
      it 'throws an error when non-200 response is received' do
        expect{BggApi.search(query)}.to raise_error
      end
    end
  end

  context 'with stubbed responses' do
    let(:expected_response) { File.open(response_file) }

    before do
      stub_request(:any, request_url)
        .with(query: query)
        .to_return(body: expected_response, status: 200)
    end

    describe 'BGG Search' do
      let(:query) { {query: 'Burgund', type: 'boardgame'} }
      let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/search' }
      let(:response_file) { 'sample_data/search?query=Burgund&type=boardgame' }

      subject(:results) { BggApi.search(query) }

      it { should_not be_nil }
    end

    describe 'BGG Thing' do
      let(:query) { {id: '84876', type: 'boardgame'} }
      let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/thing' }
      let(:response_file) { 'sample_data/thing?id=84876&type=boardgame' }

      subject(:results) { BggApi.thing(query) }

      it { should_not be_nil }

      it 'retrieves the correct id' do
        results['item'][0]['id'].should == '84876'
      end
    end

    describe 'BGG Collection' do
      let(:query) { {own: '1', username: 'texasjdl', type: 'boardgame'} }
      let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/collection' }
      let(:response_file) { 'sample_data/collection?username=texasjdl&own=1&excludesubtype=boardgameexpansion' }

      subject(:results) { BggApi.collection(query) }

      it { should_not be_nil }

      it 'retrieves the correct id' do
        results['item'][0]['objectid'].should == '421'
      end
    end

    describe 'BGG Hot Items' do
      let(:query) { {type: 'boardgame'} }
      let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/hot' }
      let(:response_file) { 'sample_data/hot?type=boardgame' }

      subject(:results) { BggApi.hot(query) }

      it { should_not be_nil }

      it 'retrieves the correct rank' do
        results['item'][0]['rank'].should == '1'
      end
    end

    describe 'BGG Plays' do
      let(:query) { {id: '84876', username: 'texasjdl'} }
      let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/plays' }
      let(:response_file) { 'sample_data/plays?username=texasjdl&id=84876' }

      subject(:results) { BggApi.plays(query) }

      it { should_not be_nil }

      it 'retrieves the correct total' do
        results['total'].should == '27'
      end
    end

    describe 'BGG User' do
      context 'who exists' do
        let(:query) { {name: 'texasjdl'} }
        let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/user' }
        let(:response_file) { 'sample_data/user?name=texasjdl' }

        subject(:results) { BggApi.user(query) }

        it { should_not be_nil }

        it 'has a yearregistered value' do
          results['yearregistered'][0]['value'].should == '2004'
        end
      end

      context 'who does not exist' do
        let(:query) { {name: 'yyyyyyy'} }
        let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/user' }
        let(:response_file) { 'sample_data/user?name=yyyyyyy' }

        subject(:results) { BggApi.user(query) }

        it { should raise_error }
      end
    end
  end
end

require 'spec_helper'

describe 'BggApi basic API calls' do
  context 'when calling an undefined method' do
    subject { BggApi.foo }

    it 'raises an UndefinedMethodError' do
      expect { subject }.to raise_error(NoMethodError)
    end
  end

  context 'when non-200 responses' do
    let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/search' }
    let(:expected_response) { '<?xml version="1.0" encoding="utf-8"?><items><item/><items>' }

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

    describe 'BGG Collection' do
      let(:username) { 'texasjdl' }
      let(:params) { {own: '1', type: 'boardgame'} }
      let(:query) { params.merge({ username: username }) }
      let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/collection' }
      let(:expected_response) { '<?xml version="1.0" encoding="utf-8"?><items><item/><items>' }

      subject { BggApi.collection username, params }

      it { expect( subject ).to be_instance_of Bgg::Result::Collection }
    end

    describe 'BGG Guild' do
      let(:id) { 1234 }
      let(:params) { { page: 2 } }
      let(:query) { params.merge({ id: id, members: 1 }) }
      let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/guild' }
      let(:expected_response) { '<?xml version="1.0" encoding="utf-8"?><guild></guild>' }

      subject { BggApi.guild id, params }

      it { expect( subject ).to be_instance_of Bgg::Result::Guild }
    end

    describe 'BGG Hot Items' do
      let(:query) { {type: 'boardgame'} }
      let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/hot' }
      let(:expected_response) { '<?xml version="1.0" encoding="utf-8"?><items><item/></items>' }

      subject { BggApi.hot query }

      it { expect( subject ).to be_instance_of Bgg::Result::Hot }
    end

    describe 'BGG Plays' do
      let(:thing_id) { 84876 }
      let(:username) { 'texasjd1' }
      let(:query) { { id: thing_id, username: username } }
      let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/plays' }
      let(:expected_response) { '<?xml version="1.0" encoding="utf-8"?><plays><play/></plays>' }

      subject(:results) { BggApi.plays username, thing_id }

      it { expect( subject ).to be_instance_of Bgg::Result::Plays }
    end

    describe 'BGG Search' do
      let(:search) { 'Marvel' }
      let(:params) { { query: search } }
      let(:query) { params }
      let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/search' }
      let(:expected_response) { '<?xml version="1.0" encoding="utf-8"?><items><item/><items>' }

      subject { BggApi.search search }

      it { expect( subject ).to be_instance_of Bgg::Result::Search }
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

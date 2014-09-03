require 'spec_helper'

describe Bgg::Request::Guild do
  let(:query) { {} }
  let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/guild' }
  let(:response_body) { '<?xml version="1.0" encoding="utf-8"?><guild></guild>' }

  subject { Bgg::Request::Guild.new id }

  before do
    stub_request(:any, request_url).
      with(query: query).
      to_return(body: response_body, status:200)
  end

  describe '.new' do
    let(:id) { nil }

    context 'throws an ArgumentError when id is not present' do
      it do
        expect{ Bgg::Request::Guild.new nil }.to raise_error ArgumentError
        expect{ Bgg::Request::Guild.new '' }.to raise_error ArgumentError
      end
    end

    context 'valid id' do
      let(:id) { 1234 }
      let(:query) { { id: id, members: 1 } }

      it do
        expect( subject ).to be_instance_of Bgg::Request::Guild
        expect( subject.get ).to be_instance_of Bgg::Result::Guild
      end

      context 'with members param' do
        let(:members) { 0 }
        let(:query) { { id: id, members: members } }

        subject { Bgg::Request::Guild.new id, { members: members } }

        it do
          expect( subject ).to be_instance_of Bgg::Request::Guild
          expect( subject.get ).to be_instance_of Bgg::Result::Guild
        end
      end
    end
  end

  describe '#member_sort_date' do
    let(:id) { 1234 }
    let(:query) { { id: id, members: 1, sort: 'date' } }

    it do
      expect( subject.member_sort_date ).to be_instance_of Bgg::Request::Guild
      expect( subject.member_sort_date.get ).to be_instance_of Bgg::Result::Guild
    end
  end

  describe '#member_sort_username' do
    let(:id) { 1234 }
    let(:query) { { id: id, members: 1, sort: 'username' } }

    it do
      expect( subject.member_sort_username ).to be_instance_of Bgg::Request::Guild
      expect( subject.member_sort_username.get ).to be_instance_of Bgg::Result::Guild
    end
  end

  describe '#page' do
    let(:id) { 1234 }
    let(:query) { { id: id, members: 1, page: 2 } }

    it do
      expect( subject.page(2) ).to be_instance_of Bgg::Request::Guild
      expect( subject.page(2).get ).to be_instance_of Bgg::Result::Guild
    end
  end
end

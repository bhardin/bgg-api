require 'spec_helper'

describe Bgg::Result::Search::Item do
  let(:item_xml) { Nokogiri.XML(xml_string) }
  let(:xml_string) { '<items><item/></items>' }
  let(:request) { double('Bgg::Request::Search') }

  subject { Bgg::Result::Search::Item.new(item_xml.at_xpath('items/item'), request) }

  before do
    request.stub(:params).and_return( {} )
  end

  it { expect( subject ).to be_a Bgg::Result::Item }

  context 'without data' do
    its(:id)             { should eq nil }
    its(:name)           { should eq nil }
    its(:type)           { should eq nil }
    its(:year_published) { should eq nil }
  end

  context 'with data' do
    let(:id)             { 1234 }
    let(:name)           { 'abc' }
    let(:type)           { 'def' }
    let(:year_published) { 2014 }
    let(:xml_string) { "
      <items>
        <item type='#{type}' id='#{id}'>
          <name value='#{name}'/>
          <yearpublished value='#{year_published}'/>
        </item>
      </items>" }

    its(:id)             { should eq id }
    its(:name)           { should eq name }
    its(:type)           { should eq type }
    its(:year_published) { should eq year_published }

    describe '#game' do
      #TODO refactor once Things have been coverted
      let(:response_file) { 'sample_data/thing?id=70512&type=boardgame' }
      let(:request_url) { 'http://www.boardgamegeek.com/xmlapi2/thing' }

      before do
        stub_request(:any, request_url).
          with(query: {id: 1234, type: 'boardgame'}).
          to_return(body: File.open(response_file), status: 200)
      end

      it 'returns a Bgg::Game object corresponding to the entry' do
        expect( subject.game ).to be_instance_of(Bgg::Game)
      end
    end
  end

  context 'with live data' do
    let(:response_file)  { 'sample_data/search.xml' }
    let(:xml_string)     { File.open(response_file) }

    its(:id)             { should_not eq nil }
    its(:name)           { should_not eq nil }
    its(:type)           { should_not eq nil }
    its(:year_published) { should_not eq nil }
  end
end

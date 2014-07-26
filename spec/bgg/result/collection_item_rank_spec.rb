require 'spec_helper'

describe Bgg::Result::Collection::Item::Rank do
  let(:item_xml) { Nokogiri.XML(xml_string) }
  let(:xml_string) { '<ranks><rank type="family"/></ranks>' }
  let(:request) { double('Bgg::Request::Collection') }

  subject { Bgg::Result::Collection::Item::Rank.new(item_xml.at_xpath('ranks/rank[@type="family"]'), request) }

  before do
    request.stub(:params).and_return( {} )
  end

  it { expect( subject ).to be_a Bgg::Result::Item }

  context 'without data' do
    its(:id)     { should eq nil }
    its(:rank)   { should eq nil }
    its(:rating) { should eq nil }
    its(:title)  { should eq nil }
  end

  context 'with data' do
    let(:id)     { 1234 }
    let(:rank)   { 56 }
    let(:rating) { 7.89012 }
    let(:title)  { 'abc' }
    let(:xml_string) { "<ranks>
                          <rank type='family'
                                id='#{id}'
                                friendlyname='#{title}'
                                value='#{rank}'
                                bayesaverage='#{rating}'/>
                        </ranks>"}

    its(:id)     { should eq id }
    its(:rank)   { should eq rank }
    its(:rating) { should eq rating }
    its(:title)  { should eq title }
  end
end

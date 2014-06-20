require 'spec_helper'

describe Bgg::Result::Base do
  let(:item_xml) { Nokogiri.XML(xml_string) }
  let(:xml_string) { '<items><item/></items>' }
  let(:request) { double('Bgg::Request::Base') }

  subject { Bgg::Result::Base.new item_xml.at_xpath('items/item'), request }

  before do
    request.stub(:params).and_return( {} )
  end

  it { expect( subject ).to respond_to :request, :xml }
  its(:request_params) { should be_a Hash }

  context 'fetch values' do

    describe '#xpath_value' do
      let(:string) { 'monkey' }

      context 'attribute' do
        let(:xml_string) { "<items><item attr='#{string}'/></items>" }
        it { expect( subject.xpath_value '@attr' ).to eq string }
      end

      context 'element text' do
        let(:xml_string) { "<items><item><el>#{string}</el></item></items>" }
        it { expect( subject.xpath_value 'items/item/el', item_xml ).to eq string }
      end
    end

    describe '#xpath_value_boolean' do
      let(:xml_string) { "<items><item attr='#{truefalse}'/></items>" }

      context 'true' do
        let(:truefalse) { 1 }
        it { expect( subject.xpath_value_boolean '@attr' ).to be_true }
      end

      context 'false' do
        let(:truefalse) { 0 }
        it { expect( subject.xpath_value_boolean 'items/item/@attr', item_xml ).to be_false }
      end
    end

    describe '#xpath_value_date' do
      let(:xml_string) { "<items><item attr='#{date.to_s}'/></items>" }

      context 'valid' do
        let(:date)       { Date.new(2000, 1, 1) }
        it { expect( subject.xpath_value_date '@attr' ).to eq date }
      end

      context 'invalid' do
        let(:date)       { 'monkey brains' }
        it { expect( subject.xpath_value_date 'items/item/@attr', item_xml ).to eq nil }
      end
    end

    describe '#xpath_value_float' do
      let(:xml_string) { "<items><item attr='#{float}'/></items>" }

      context 'valid' do
        let(:float) { 1.23 }
        it { expect( subject.xpath_value_float '@attr' ).to eq float }
      end

      context 'invalid' do
        let(:float) { 'code monkey' }
        it { expect( subject.xpath_value_float 'items/item/@attr', item_xml ).to eq nil }
      end
    end

    describe '#xpath_value_int' do
      let(:xml_string) { "<items><item attr='#{int}'/></items>" }

      context 'valid' do
        let(:int) { 1234 }
        it { expect( subject.xpath_value_int '@attr' ).to eq int }
      end

      context 'invalid' do
        let(:int) { 'monkey wrench or spanner or whatever' }
        it { expect( subject.xpath_value_int 'items/item/@attr', item_xml ).to eq nil }
      end
    end

    describe '#xpath_value_time' do
      let(:xml_string) { "<items><item attr='#{time_string}'/></items>" }

      context 'valid' do
        let(:time) { DateTime.new 2000, 1, 1, 0, 0, 0, '+00:00' }
        let(:time_string) { time.strftime '%a, %d %b %Y %T %z' }
        it { expect( subject.xpath_value_time '@attr' ).to eq time }
      end

      context 'invalid' do
        let(:time_string) { 'monkey wrench or spanner or whatever' }
        it { expect( subject.xpath_value_time 'items/item/@attr', item_xml ).to eq nil }
      end
    end

    describe '#xpath_values' do
      let(:xml_string) { "<items><item><type name='#{type.first}'/><type name='#{type.last}'/></item></items>" }
      let(:type) { ['monkey','work'] }
      it { expect( subject.xpath_values 'type/@name' ).to eq type }
      it { expect( subject.xpath_values 'items/item/type/@name', item_xml ).to eq type }
    end
  end

end

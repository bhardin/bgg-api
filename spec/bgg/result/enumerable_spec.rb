require 'spec_helper'

module Bgg
  module Result
    class Enumerable
      class Item < Item
      end
    end
  end
end

describe Bgg::Result::Enumerable do
  let(:item_xml) { Nokogiri.XML(xml_string) }
  let(:xml_string) { '<items><item/><item/></items>' }
  let(:request) { double('Bgg::Request::Base') }

  subject { Bgg::Result::Enumerable.new item_xml, request }

  context "enumerable" do
    its(:count) { should eq 2 }
    it { expect( subject.first ).to be_instance_of subject.class::Item }
  end
end

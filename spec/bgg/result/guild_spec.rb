require 'spec_helper'

describe Bgg::Result::Guild do
  let(:item_xml) { Nokogiri.XML(xml_string) }
  let(:params) { {} }
  let(:xml_string) { '<guild><members/></guild>' }
  let(:request) { double('Bgg::Request::Guild') }

  subject { Bgg::Result::Guild.new(item_xml.at_xpath('guild'), request) }

  before do
    request.stub(:params).and_return(params)
  end

  context 'without data' do
    its(:address)        { should eq nil }
    its(:category)       { should eq nil }
    its(:city)           { should eq nil }
    its(:country)        { should eq nil }
    its(:created)        { should eq nil }
    its(:description)    { should eq nil }
    its(:id)             { should eq nil }
    its(:manager)        { should eq nil }
    its(:member_count)   { should eq nil }
    its(:member_page)    { should eq nil }
    its(:member_usernames) { should eq [] }
    its(:members)        { should eq [] }
    its(:name)           { should eq nil }
    its(:postal_code)    { should eq nil }
    its(:state)          { should eq nil }
    its(:website)        { should eq nil }
  end

  context 'with data' do
    let(:address)        { "#{address1} #{address2}" }
    let(:address1)       { 'my address1' }
    let(:address2)       { 'my address2' }
    let(:category)       { 'my category' }
    let(:city)           { 'my city' }
    let(:country)        { 'my country' }
    let(:created)        { DateTime.new(2002, 1, 1, 0, 0, 0, '+00:00') }
    let(:created_string) { created.strftime '%a, %d %b %Y %T %z' }
    let(:description)    { 'my description' }
    let(:id)             { 1234 }
    let(:manager)        { 'abc' }
    let(:member_count)   { 56 }
    let(:member_page)    { 2 }
    let(:name)           { 'def' }
    let(:postal_code)    { 'my postal code' }
    let(:state)          { 'my state' }
    let(:website)        { 'http://mywebsite.com' }

    let(:params)         { { id: id } }
    let(:xml_string) {"<guild id='#{id}'
                              name='#{name}'
                              created='#{created_string}'>
                         <category>#{category}</category>
                         <website>#{website}</website>
                         <manager>#{manager}</manager>
                         <description>#{description}</description>
                         <location>
                           <addr1>#{address1}</addr1>
                           <addr2>#{address2}</addr2>
                           <city>#{city}</city>
                           <stateorprovince>#{state}</stateorprovince>
                           <postalcode>#{postal_code}</postalcode>
                           <country>#{country}</country>
                         </location>
                         <members count='#{member_count}' page='#{member_page}'>
                           <member name='#{manager}' date='#{created_string}'/>
                         </members>
                       </guild>"}

    its(:address)        { should eq address }
    its(:category)       { should eq category }
    its(:city)           { should eq city }
    its(:country)        { should eq country }
    its(:created)        { should eq created }
    its(:description)    { should eq description }
    its(:id)             { should eq id }
    its(:manager)        { should eq manager }
    its(:member_count)   { should eq member_count }
    its(:member_page)    { should eq member_page }
    its(:member_usernames) { should eq [ manager ] }
    its(:members)        { should eq [ { name: manager, date: created } ] }
    its(:name)           { should eq name }
    its(:postal_code)    { should eq postal_code }
    its(:state)          { should eq state }
    its(:website)        { should eq website }
  end

  context 'with live data' do
    let(:params)         { { id: 1551 } }
    let(:response_file)  { 'sample_data/guild.xml' }
    let(:xml_string)     { File.open(response_file) }

    its(:address)        { should_not eq nil }
    its(:category)       { should_not eq nil }
    its(:city)           { should_not eq nil }
    its(:country)        { should_not eq nil }
    its(:created)        { should_not eq nil }
    its(:description)    { should_not eq nil }
    its(:id)             { should_not eq nil }
    its(:manager)        { should_not eq nil }
    its(:member_count)   { should_not eq nil }
    its(:member_page)    { should_not eq nil }
    its(:member_usernames) { should_not eq nil }
    its(:members)        { should_not eq nil }
    its(:name)           { should_not eq nil }
    its(:postal_code)    { should_not eq nil }
    its(:state)          { should_not eq nil }
    its(:website)        { should_not eq nil }
  end
end

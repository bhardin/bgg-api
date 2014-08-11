module Bgg
  module Result
    class Guild < Item
      attr_reader :address, :category, :city, :country, :created,
                  :description, :id, :manager, :member_count, :member_page,
                  :name, :postal_code, :state, :website

      def initialize(item, request)
        super item, request

        addr1 = xpath_value('location/addr1')
        addr2 = xpath_value('location/addr2')
        @address = "#{addr1} #{addr2}" if(addr1 || addr2)
        @category = xpath_value('category')
        @city = xpath_value('location/city')
        @country = xpath_value('location/country')
        @created = xpath_value_time('@created')
        @description = xpath_value('description')
        @id = request_params[:id]
        @manager = xpath_value('manager')
        @member_count = xpath_value_int('members/@count')
        @member_page = xpath_value_int('members/@page')
        @name = xpath_value('@name')
        @postal_code = xpath_value('location/postalcode')
        @state = xpath_value('location/stateorprovince')
        @website = xpath_value('website')
      end

      def member_usernames
        members.map { |member| member[:name] }
      end

      def members
        @members ||= @xml.xpath('members/member').map do |member|
          { name: xpath_value('@name', member), date: xpath_value_time('@date', member) }
        end
      end
    end
  end
end

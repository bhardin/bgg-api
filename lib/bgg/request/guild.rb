module Bgg
  module Request
    class Guild < Base

      def initialize(id, params = {})
        if invalid_id(id)
          raise ArgumentError.new 'missing required argument'
        else
          params[:id] = id
        end
        params[:members] = 1 unless params.has_key? :members

        super :guild, params
      end

      def page(num)
        @params.merge!( { page: num })
        self
      end

      def member_sort_date
        member_sort 'date'
      end

      def member_sort_username
        member_sort 'username'
      end

      private

      def member_sort(type)
        @params.merge!( { sort: type })
        self
      end
    end
  end
end

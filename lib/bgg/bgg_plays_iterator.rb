module Bgg
  class Plays
    class Iterator
      include Enumerable

      attr_reader :total_count, :iteration

      def initialize(username)
        @iteration = 0
        @page = 1
        @empty = false
        @total_count = 0
        @username = username

        begin
          raw_data = BggApi.plays({username: @username, page: @page})
          @total_count = raw_data.fetch('total', '0').to_i
          @items = raw_data['play']
          @empty = true if @total_count == 0
        rescue REXML::ParseException
          # this will happen if the user does not exist
          raise ArgumentError.new('user does not exist')
        end
      end

      def each &block
        return if empty?

        while @page <= total_pages
          @items.each do |item|
            @iteration += 1
            yield Bgg::Play.new(item)
            return if @iteration == total_count
          end

          fetch_next_page
        end

      ensure
        @empty = true
      end

      def empty?
        @empty
      end

      private

      def fetch_page(page)
        raw_data = BggApi.plays({username: @username, page: page})
        @items = raw_data['play']
      end

      def fetch_next_page
        fetch_page(@page + 1)
        @page = @page + 1
      end

      def total_pages
        (total_count / 100.0).ceil.to_i
      end
    end
  end
end

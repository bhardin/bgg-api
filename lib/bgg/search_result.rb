module Bgg
  class Search
    class Result
      attr_reader :id, :name, :type, :year_published

      def initialize(result_item)
        @id             = result_item['id'].to_i
        @name           = result_item['name'][0]['value']
        @type           = result_item['type']
        @year_published = result_item.fetch('yearpublished', [{'value' => '0'}])[0]['value'].to_i
      end

      def game
        Bgg::Game.find_by_id(self.id)
      end
    end
  end
end

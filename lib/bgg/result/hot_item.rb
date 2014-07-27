module Bgg
  module Result
    class Hot
      class Item < Item
        attr_reader :id, :name, :rank, :thumbnail, :type, :year_published

        def initialize(item, request)
          super item, request
          @type = request_params[:type] || 'boardgame'

          @id = xpath_value_int '@id'
          @name = xpath_value 'name/@value'
          @rank = xpath_value_int '@rank'
          @thumbnail = xpath_value 'thumbnail/@value'
          @year_published = xpath_value_int 'yearpublished/@value'
        end

        def game
          #TODO refactor once Things have been coverted, also needs to
          #account for different types.
          Bgg::Game.find_by_id(self.id)
        end
      end
    end
  end
end

module Bgg
  module Result
    class Plays < Enumerable
      attr_reader :page, :thing_id, :total_count, :username

      def initialize(item, request)
        super item, request

        @page         = request_params[:page] || 1
        @thing_id     = request_params[:id]
        @total_count  = xpath_value_int 'plays/@total'
        @username     = request_params[:username]
      end

      def find_by_date(date)
        if date.kind_of? Range
          select { |play| date.cover? play.date }
        else
          select { |play| play.date === date }
        end
      end

      def find_by_location(location)
        select { |play| play.location == location }
      end

      def find_by_thing_id(id)
        select { |play| play.id == id }
      end

      def find_by_thing_name(name)
        select { |play| play.name == name }
      end

      def board_game_expansions
        find_by_type 'boardgameexpansion'
      end

      def board_game_implementations
        find_by_type 'boardgameimplementation'
      end

      def board_games
        find_by_type 'boardgame'
      end

      def rpg_items
        find_by_type 'rpgitem'
      end

      def video_games
        find_by_type 'videogame'
      end

      private

      def parse
        super 'plays/play', self.class::Play
      end

      def find_by_type type
        select{ |play| play.types and play.types.include? type }
      end
    end
  end
end

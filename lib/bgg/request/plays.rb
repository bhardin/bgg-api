module Bgg
  module Request
    class Plays < Base

      BOARD_GAME_EXPANSIONS = { subtype: 'boardgameexpansion' }
      BOARD_GAME_IMPLEMENTATIONS = { subtype: 'boardgameimplementation' }
      BOARD_GAMES = { subtype: 'boardgame' }
      RPGS = { subtype: 'rpgitem' }
      VIDEO_GAMES = { subtype: 'videogame' }

      def self.board_game_expansions(username, thing_id, params = {})
        Bgg::Request::Plays.new username, thing_id, params.merge!(BOARD_GAME_EXPANSIONS)
      end

      def self.board_game_implementations(username, thing_id, params = {})
        Bgg::Request::Plays.new username, thing_id, params.merge!(BOARD_GAME_IMPLEMENTATIONS)
      end

      def self.board_games(username, thing_id, params = {})
        Bgg::Request::Plays.new username, thing_id, params.merge!(BOARD_GAMES)
      end

      def self.rpgs(username, thing_id, params = {})
        Bgg::Request::Plays.new username, thing_id, params.merge!(RPGS)
      end

      def self.video_games(username, thing_id, params = {})
        Bgg::Request::Plays.new username, thing_id, params.merge!(VIDEO_GAMES)
      end

      def initialize(username, thing_id, params = {})
        if invalid_username(username) && invalid_id(thing_id)
          raise ArgumentError.new 'missing required argument'
        else
          params[:username] = username unless invalid_username username
          params[:id] = thing_id unless invalid_id thing_id
        end

        super :plays, params
      end

      def date(date)
        if date.kind_of? Range
          min_date = date.first
          max_date = date.last
        else
          min_date = date
          max_date = date
        end
        @params.merge!( { mindate: min_date.to_s, maxdate: max_date.to_s })
        self
      end

      def page(num)
        @params.merge!( { page: num })
        self
      end
    end
  end
end

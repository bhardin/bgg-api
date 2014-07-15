module Bgg
  module Request
    class Collection < Base

      BOARD_GAMES = {
        subtype: 'boardgame',
        excludesubtype: 'boardgameexpansion'
      }
      BOARD_GAME_EXPANSIONS = { subtype: 'boardgameexpansion' }
      RPGS = { subtype: 'rpgitem' }
      VIDEO_GAMES = { subtype: 'videogame' }

      ALL_FIELDS = { showprivate: 1, stats: 1, version: 1 }
      BRIEF = { brief: 1 }

      def self.board_games(username, params = {})
        Bgg::Request::Collection.new username, params.merge!(BOARD_GAMES)
      end

      def self.board_game_expansions(username, params = {})
        Bgg::Request::Collection.new username, params.merge!(BOARD_GAME_EXPANSIONS)
      end

      def self.rpgs(username, params = {})
        Bgg::Request::Collection.new username, params.merge!(RPGS)
      end

      def self.video_games(username, params = {})
        Bgg::Request::Collection.new username, params.merge!(VIDEO_GAMES)
      end

      def initialize(username, params = {})
        if invalid_username username
          raise ArgumentError.new 'missing required username'
        else
          params[:username] = username
        end

        super :collection, params
      end

      def all_fields
        @params.merge!(ALL_FIELDS)
        self
      end

      def brief
        @params.merge!(BRIEF)
        self
      end

    end
  end
end

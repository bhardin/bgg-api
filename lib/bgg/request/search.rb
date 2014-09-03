module Bgg
  module Request
    class Search < Base

      BOARD_GAMES = { type: 'boardgame' }
      BOARD_GAME_EXPANSIONS = { type: 'boardgameexpansion' }
      RPG_ISSUES = { type: 'rpgissue' }
      RPG_ITEMS = { type: 'rpgitem' }
      RPG_PERIODICALS = { type: 'rpgperiodical' }
      RPGS = { type: 'rpg' }
      VIDEO_GAMES = { type: 'videogame' }

      EXACT = { exact: 1 }

      def self.board_games(query, params = {})
        Bgg::Request::Search.new query, params.merge!(BOARD_GAMES)
      end

      def self.board_game_expansions(query, params = {})
        Bgg::Request::Search.new query, params.merge!(BOARD_GAME_EXPANSIONS)
      end

      def self.rpg_issues(query, params = {})
        Bgg::Request::Search.new query, params.merge!(RPG_ISSUES)
      end

      def self.rpg_items(query, params = {})
        Bgg::Request::Search.new query, params.merge!(RPG_ITEMS)
      end

      def self.rpg_periodicals(query, params = {})
        Bgg::Request::Search.new query, params.merge!(RPG_PERIODICALS)
      end

      def self.rpgs(query, params = {})
        Bgg::Request::Search.new query, params.merge!(RPGS)
      end

      def self.video_games(query, params = {})
        Bgg::Request::Search.new query, params.merge!(VIDEO_GAMES)
      end

      def initialize(query, params = {})
        if query.nil? || query.empty?
          raise ArgumentError.new 'missing required query'
        else
          params[:query] = query
        end

        super :search, params
      end

      def exact
        @params.merge!(EXACT)
        self
      end

    end
  end
end

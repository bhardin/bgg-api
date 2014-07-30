module Bgg
  module Request
    class Hot < Base

      BOARD_GAME_COMPANIES = { type: 'boardgamecompany' }
      BOARD_GAME_PEOPLE = { type: 'boardgameperson' }
      BOARD_GAMES = { type: 'boardgame' }
      RPG_COMPANIES = { type: 'rpgcompany' }
      RPG_PEOPLE = { type: 'rpgperson' }
      RPGS = { type: 'rpg' }
      VIDEO_GAMES = { type: 'videogame' }
      VIDEO_GAME_COMPANIES = { type: 'videogamecompany' }

      EXACT = { exact: 1 }

      def self.board_game_companies(params = {})
        Bgg::Request::Hot.new params.merge!(BOARD_GAME_COMPANIES)
      end

      def self.board_game_people(params = {})
        Bgg::Request::Hot.new params.merge!(BOARD_GAME_PEOPLE)
      end

      def self.board_games(params = {})
        Bgg::Request::Hot.new params.merge!(BOARD_GAMES)
      end

      def self.rpg_companies(params = {})
        Bgg::Request::Hot.new params.merge!(RPG_COMPANIES)
      end

      def self.rpg_people(params = {})
        Bgg::Request::Hot.new params.merge!(RPG_PEOPLE)
      end

      def self.rpgs(params = {})
        Bgg::Request::Hot.new params.merge!(RPGS)
      end

      def self.video_game_companies(params = {})
        Bgg::Request::Hot.new params.merge!(VIDEO_GAME_COMPANIES)
      end

      def self.video_games(params = {})
        Bgg::Request::Hot.new params.merge!(VIDEO_GAMES)
      end

      def initialize(params = {})
        super :hot, params
      end

    end
  end
end

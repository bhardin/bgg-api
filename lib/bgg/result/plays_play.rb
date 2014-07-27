module Bgg
  module Result
    class Plays
      class Play < Enumerable

        attr_reader :comment, :date, :id, :length, :location, :name,
                    :quantity, :type, :types

        def initialize(item, request)
          super item, request

          @comment      = xpath_value 'comments'
          @date         = xpath_value_date '@date'
          @id           = xpath_value_int 'item/@objectid'
          @incomplete   = xpath_value_boolean '@incomplete'
          @length       = xpath_value_int '@length'
          @location     = xpath_value '@location'
          @name         = xpath_value 'item/@name'
          @now_in_stats = xpath_value_boolean '@nowinstats'
          @quantity     = xpath_value_int '@quantity'
          @types        = xpath_values 'item/subtypes/subtype/@value'
        end

        def type
          @types.first unless @types.nil?
        end

        def now_in_stats?
          @now_in_stats unless @now_in_stats.nil?
        end

        def incomplete?
          @incomplete unless @incomplete.nil?
        end

        def players
          @items unless @items.empty?
        end

        def winner
          found = @items.detect { |item| item.winner? }
          found.username.empty? ? found.name : found.username unless found.nil?
        end

        def game
          #TODO refactor once Things have been coverted
          Bgg::Game.find_by_id(self.id)
        end

        private

        def parse
          super 'players/player', self.class::Player
        end

        class Player < Item

          attr_reader :color, :id, :name, :rating, :score, :start_position, :username

          def initialize(xml, request)
            super xml, request
            @color = xpath_value '@color'
            @id = xpath_value_int '@userid'
            @name = xpath_value '@name'
            @new = xpath_value_boolean '@new'
            @rating = xpath_value_float '@rating'
            @score = xpath_value_int '@score'
            @start_position = xpath_value '@startposition'
            @username = xpath_value '@username'
            @winner = xpath_value_boolean '@win'
          end

          def new?
            @new unless @new.nil?
          end

          def winner?
            @winner unless @winner.nil?
          end
        end
      end
    end
  end
end

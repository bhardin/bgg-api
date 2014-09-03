module Bgg
  module Result
    class Collection < Enumerable

      def owned
        @items.select { |item| item.owned? }
      end

      def played
        @items.select{ |item| item.played? }
      end

      def user_rated(value = nil)
        @items.select do |item|
          if value.kind_of? Range and !item.user_rating.nil?
            value.include? item.user_rating.floor
          elsif value.kind_of? Integer and !item.user_rating.nil?
            item.user_rating.floor == value
          elsif value.nil?
            !item.user_rating.nil?
          end
        end
      end
    end
  end
end

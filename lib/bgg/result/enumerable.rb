module Bgg
  module Result
    class Enumerable < Item
      include ::Enumerable

      def initialize(xml, request)
        super xml, request
        @items = parse
      end

      def each &block
        @items.each do |item|
          block.call item
        end
      end

      private

      def parse(path = 'items/item', item_class = self.class::Item)
        @xml.xpath(path).map do |item|
          item_class.new item, @request
        end
      end
    end
  end
end

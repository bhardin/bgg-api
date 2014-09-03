module Bgg
  module Result
    class Collection
      class Item
        class Rank < Item
          attr_reader :id, :rank, :rating, :title

          def initialize(item, request)
            super item, request

            @id     = xpath_value_int '@id'
            @title  = xpath_value '@friendlyname'
            @rank   = xpath_value_int '@value'
            @rating = xpath_value_float '@bayesaverage'
          end
        end
      end
    end
  end
end

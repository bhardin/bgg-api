module Bgg
  module Result
    class Hot < Enumerable
      attr_reader :type

      def initialize(xml, request)
        super xml, request
        @type = request_params[:type] || 'boardgame'
      end
    end
  end
end

module Bgg
  module Result
    class Item

      attr_reader :request, :xml

      def initialize(xml, request)
        @xml = xml
        @request = request
      end

      def request_params
        @request.params
      end

      def xpath_value(path, xml = @xml)
        node_value xml.at_xpath path
      end

      def xpath_value_boolean(path, xml = @xml)
        value = xpath_value path, xml
        if value
          value == '1'
        end
      end

      def xpath_value_date(path, xml = @xml)
        value = xpath_value path, xml
        if value
          Date.strptime value, '%F' rescue nil
        end
      end

      def xpath_value_float(path, xml = @xml)
        value = xpath_value path, xml
        if value
          Float(value) rescue nil
        end
      end

      def xpath_value_int(path, xml = @xml)
        value = xpath_value path, xml
        if value
          Integer(value) rescue nil
        end
      end

      def xpath_value_time(path, xml = @xml)
        value = xpath_value path, xml
        if value
          DateTime.strptime(value, '%a, %d %b %Y %T %z') rescue nil
        end
      end

      def xpath_values(path, xml = @xml)
        nodes = xml.xpath path
        nodes.map do |node|
          node_value node
        end unless nodes.empty?
      end

      private

      def node_value(node)
        if node.instance_of? Nokogiri::XML::Attr
          node.value
        elsif node.instance_of? Nokogiri::XML::Element
          node.text
        end
      end

    end
  end
end

require 'httparty'
require 'rexml/document'

# http://boardgamegeek.com/wiki/page/BGG_XML_API2#

class BggApi
  include HTTParty

  @@base_uri = "http://www.boardgamegeek.com/xmlapi2"

  protected
  
    def call(method, params = {})
      response = HTTParty.get(@@base_uri + '/' + method.to_s + '/', :query => params)
      
      if response.code == 200
        xml_data = response.body
        puts xml_data
      else
        raise response.code
      end
    end
    
    def method_missing(method, *args)
      puts "Method name: #{method}"
      call(method, *args)
    end
  
    def respond_to?(method)
        true
    end

end

bgg = BggApi.new
bgg.search({:query => "Burgund", :type => 'boardgame'})
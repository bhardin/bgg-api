require 'httparty'
require 'xmlsimple'

# http://boardgamegeek.com/wiki/page/BGG_XML_API2#

# because this uses method_missing, the fact that we're including the HTTParty
# module below into the namespace doesn't seem to help. Likewise with the
# base_uri method. There's probably some trick to getting this to work, but
# I haven't yet figured it out and will put it on the list, but later in the
# process.

class BggApi
  include HTTParty

  @@base_uri = "http://www.boardgamegeek.com/xmlapi2"

  protected
  
    def call(method, params = {})
      response = HTTParty.get(@@base_uri + '/' + method.to_s, :query => params)
      
      if response.code == 200
        xml_data = response.body
        XmlSimple.xml_in(xml_data)
      else
        raise response.code
      end
    end
    
    def method_missing(method, *args)
      call(method, *args)
    end
  
    def respond_to?(method)
        true
    end

end

#bgg = BggApi.new
#puts bgg.search({:query => "Burgund", :type => 'boardgame'})
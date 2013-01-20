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
  @@old_uri = "http://www.boardgamegeek.com/xmlapi"

  def self.search_by_name(name,type='boardgame')

    response = HTTParty.get(@@base_uri + '/search', :query=> {:query => name, :type => type})

    return if response.code != 200

    result = Array.new
    xml = XmlSimple.xml_in(response.body)
    return if xml["total"]=="0"

    xml["item"].each do  |item|
      result << Hash[:name, item["name"][0]["value"], :type, item["type"],  :id , item["id"].to_i]
    end
    return result
  end

  def self.search_boardgame_by_id(id,type='boardgame')
    response = HTTParty.get(@@old_uri + '/boardgame/'+id.to_s)
    return if response.code != 200

    xml = XmlSimple.xml_in(response.body)
    @alternate_names = Array.new
    xml["boardgame"][0]["name"].each_with_index do |name,index|
      if name["primary"]=="true"
        @primary_name=name["content"]
        primary_index = index
      else
        @alternate_names <<name["content"]
      end
      xml["boardgame"][0]["name"].slice!(primary_index) unless primary_index.nil?
    end
    return Hash[:id, id, :name, @primary_name,:minplayers,xml["boardgame"][0]["minplayers"][0],:maxplayers,xml["boardgame"][0]["maxplayers"][0],
                :age,xml["boardgame"][0]["age"][0], :description, xml["boardgame"][0]["description"][0],:playingtime,xml["boardgame"][0]["playingtime"][0],
                :thumbnail,xml["boardgame"][0]["thumbnail"][0], :image ,xml["boardgame"][0]["image"][0], :alternatenames,  @alternate_names.sort,
                :yearpublished,xml["boardgame"][0]["yearpublished"][0] ]

  end


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
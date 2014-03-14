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

  METHODS = [
    :thing,
    :family,
    :forumlist,
    :forum,
    :thread,
    :user,
    :guild,
    :plays,
    :collection,
    :hot,
    :search,
  ].freeze

  BASE_URI = "http://www.boardgamegeek.com/xmlapi2"
  OLD_URI  = "http://www.boardgamegeek.com/xmlapi"

  def self.search_by_name(name,type='boardgame')

    response = HTTParty.get(BASE_URI + '/search', :query=> {:query => name, :type => type})

    return if response.code != 200

    result = Array.new
    xml = XmlSimple.xml_in(response.body)
    return if xml["total"]=="0"

    xml["item"].each do  |item|
      result << {
        :name => item["name"][0]["value"],
        :type => item["type"],
        :id   => item["id"].to_i,
      }
    end
    return result
  end

  def self.search_boardgame_by_id(id,type='boardgame')
    response = HTTParty.get(OLD_URI + '/boardgame/'+id.to_s)
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

    first_game = xml["boardgame"][0]

    return {
      :id => id,
      :name => @primary_name,
      :minplayers => first_game["minplayers"][0],
      :maxplayers => first_game["maxplayers"][0],

      :age => first_game["age"][0],
      :description =>  first_game["description"][0],
      :playingtime => first_game["playingtime"][0],

      :thumbnail => first_game["thumbnail"][0],
      :image => first_game["image"][0],
      :alternatenames =>  @alternate_names.sort,

      :yearpublished => first_game["yearpublished"][0],
    }

  end

  METHODS.each do |method|
    define_method(method) do |params|
      params ||= {}

      url = BASE_URI + '/' + method.to_s
      response = HTTParty.get(url, :query => params)

      if response.code == 200
        xml_data = response.body
        XmlSimple.xml_in(xml_data)
      else
        raise "Received a #{response.code} at #{url} with #{params}"
      end
    end
  end
end

#bgg = BggApi.new
#puts bgg.search({:query => "Burgund", :type => 'boardgame'})
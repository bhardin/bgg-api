require 'httparty'
require 'xmlsimple'

# http://boardgamegeek.com/wiki/page/BGG_XML_API2#

class BggApi
  include HTTParty

  METHODS = [
    :collection,
    :family,
    :forum,
    :forumlist,
    :guild,
    :hot,
    :plays,
    :search,
    :thing,
    :thread,
    :user,
  ].freeze

  BASE_URI = 'http://www.boardgamegeek.com/xmlapi2'
  OLD_URI  = 'http://www.boardgamegeek.com/xmlapi'

  METHODS.each do |method|
    define_singleton_method(method) do |params|
      params ||= {}

      url = BASE_URI + '/' + method.to_s
      response = self.get(url, :query => params)

      if response.code == 200
        xml_data = response.body
        XmlSimple.xml_in(xml_data)
      else
        raise "Received a #{response.code} at #{url} with #{params}"
      end
    end
  end
end


require 'bgg/bgg_collection'
require 'bgg/bgg_collection_item'
require 'bgg/bgg_game'
require 'bgg/bgg_play'
require 'bgg/bgg_plays'
require 'bgg/bgg_plays_iterator'
require 'bgg/bgg_search'
require 'bgg/bgg_search_result'
require 'bgg/bgg_user'


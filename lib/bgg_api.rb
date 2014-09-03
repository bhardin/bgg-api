require 'httparty'
require 'xmlsimple'

class BggApi
  include HTTParty

  OLD_METHODS = [
    :family,
    :forum,
    :forumlist,
    :thing,
    :thread,
    :user
  ].freeze

  NEW_METHODS = [
    :collection,
    :guild,
    :hot,
    :plays,
    :search
  ].freeze

  BASE_URI = 'http://www.boardgamegeek.com/xmlapi2'

  OLD_METHODS.each do |method|
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

  NEW_METHODS.each do |method|
    define_singleton_method method do |*params|
      request = Object.const_get('Bgg').const_get('Request').const_get(method.to_s.capitalize).new *params
      request.get
    end
  end
end


require 'bgg/request/base'
require 'bgg/request/collection'
require 'bgg/request/guild'
require 'bgg/request/hot'
require 'bgg/request/plays'
require 'bgg/request/search'

require 'bgg/result/item'
require 'bgg/result/enumerable'
require 'bgg/result/collection'
require 'bgg/result/collection_item'
require 'bgg/result/collection_item_rank'
require 'bgg/result/guild'
require 'bgg/result/hot'
require 'bgg/result/hot_item'
require 'bgg/result/plays'
require 'bgg/result/plays_play'
require 'bgg/result/search'
require 'bgg/result/search_item'

require 'bgg/game'
require 'bgg/user'


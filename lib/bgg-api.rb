require 'httparty'
require 'xmlsimple'
require 'hash_builder'

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

  def self.search_by_name(name,type='boardgame')
    response = get(BASE_URI + '/search', query: {query: name, type: type})

    return if response.code != 200

    xml = XmlSimple.xml_in(response.body)
    return if xml['total'] == '0'

    xml['item'].map do |item|
      HashBuilder.build_basic_game_results(item)
    end
  end

  def self.search_boardgame_by_id(id,type='boardgame')
    response = get("#{OLD_URI}/boardgame/#{id}")
    return unless response.code == 200

    xml = XmlSimple.xml_in(response.body)
    return if xml['boardgame'][0].has_key?('error')

    HashBuilder.build_boardgame_by_id(xml, id)

  end

  def self.entire_user_plays(username, page=1)
    response = get(BASE_URI + '/plays', :query => {:username => username, :page => page})
    return if response.code != 200

    xml = XmlSimple.xml_in(response.body)
    return if xml['total'] == '0'

    if xml['total'].to_i >= 100
      pages = (xml['total'].to_i / 100) + 1
    else
      pages = 1
    end

    plays = []
    while page <= pages
      response = get(BASE_URI + '/plays', :query => {:username => username, :page => page})
      xml = XmlSimple.xml_in(response.body)
      page += 1
      xml['play'].each do |play|
        players = Array.new
        unless play['players'] == nil
          HashBuilder.build_players(play, players)
        end
        HashBuilder.build_plays(play, players, plays)
      end
    end
    return plays
  end

  METHODS.each do |method|
    define_method(method) do |params|
      params ||= {}

      url = BASE_URI + '/' + method.to_s
      response = self.class.get(url, :query => params)

      if response.code == 200
        xml_data = response.body
        XmlSimple.xml_in(xml_data)
      else
        raise "Received a #{response.code} at #{url} with #{params}"
      end
    end
  end
end


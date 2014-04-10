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
          play['players'][0]['player'].each do |player|
            players << Hash[:name, player['name'], :win, player['win'].to_i, :score, player['score']]
          end
        end
        if players.empty?
          plays << Hash[:date, play['date'], :nowinstats, play['nowinstats'].to_i, :boardgame, play['item'][0]['name'], :objectid, play['item'][0]['objectid'].to_i, :comments, play['comments']]
        else
          plays << Hash[:date, play['date'], :nowinstats, play['nowinstats'].to_i, :boardgame, play['item'][0]['name'], :objectid, play['item'][0]['objectid'].to_i, :players, players, :comments, play['comments']]
        end
      end
    end
    return plays
  end

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


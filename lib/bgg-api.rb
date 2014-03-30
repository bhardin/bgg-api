require 'httparty'
require 'xmlsimple'

# http://boardgamegeek.com/wiki/page/BGG_XML_API2#

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

    response = get(BASE_URI + '/search', :query=> {:query => name, :type => type})

    return if response.code != 200

    result = Array.new
    xml = XmlSimple.xml_in(response.body)
    return if xml["total"]=="0"

    xml["item"].map do |item|
      {
        :name => item["name"][0]["value"],
        :type => item["type"],
        :id   => item["id"].to_i,
      }
    end
  end

  def self.search_boardgame_by_id(id,type='boardgame')
    response = get("#{OLD_URI}/boardgame/#{id}")
    return unless response.code == 200

    xml = XmlSimple.xml_in(response.body)
    game_data  = xml["boardgame"][0]
    name_nodes = game_data["name"]

    primary_node = name_nodes.find { |name| name['primary'] == 'true' }
    primary_name = primary_node['content']

    other_game_nodes = name_nodes.reject { |name| name['primary'] == 'true' }
    other_game_names = other_game_nodes.map { |node| node['content'] }

    return {
      :id => id,
      :name =>  primary_name,
      :minplayers => game_data["minplayers"][0],
      :maxplayers => game_data["maxplayers"][0],

      :age => game_data["age"][0],
      :description =>  game_data["description"][0],
      :playingtime => game_data["playingtime"][0],

      :thumbnail => game_data["thumbnail"][0],
      :image => game_data["image"][0],
      :alternatenames =>  other_game_names.sort,

      :yearpublished => game_data["yearpublished"][0],
    }

  end

  def self.entire_user_plays(username, page=1)

    response = get(BASE_URI + '/plays', :query => {:username => username, :page => page})
    return if response.code != 200

    plays = Array.new
    xml = XmlSimple.xml_in(response.body)
    return if xml["total"]=="0"

    page = 1

    if xml["total"].to_i >= 100
      pages = (xml["total"].to_i / 100) + 1
    else
      pages = 1
    end

    while page <= pages
      response = get(BASE_URI + '/plays', :query => {:username => username, :page => page})
      xml = XmlSimple.xml_in(response.body)
      page += 1
      xml["play"].each do |play|
        players = Array.new
        unless play["players"] == nil
          play["players"][0]["player"].each do |player|
            players << Hash[:name, player["name"], :win, player["win"].to_i, :score, player["score"]]
          end
        end
        if players.empty?
          plays << Hash[:date, play["date"], :nowinstats, play["nowinstats"].to_i, :boardgame, play["item"][0]["name"], :objectid, play["item"][0]["objectid"].to_i, :comments, play["comments"]]
        else
          plays << Hash[:date, play["date"], :nowinstats, play["nowinstats"].to_i, :boardgame, play["item"][0]["name"], :objectid, play["item"][0]["objectid"].to_i, :players, players, :comments, play["comments"]]
        end
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

#bgg = BggApi.new
#puts bgg.search({:query => "Burgund", :type => 'boardgame'})

require 'httparty'
require 'rexml/document'
load    'search_result.rb'

# http://boardgamegeek.com/wiki/page/BGG_XML_API2#

class BggApi
  include HTTParty

    #base_uri "rubygems.org/api/v1"
  base_uri "www.boardgamegeek.com/xmlapi2"

  def self.thing(id)
    response = get("/thing", :query => {:id => id})

    if response.success?
      response["items"]["item"]
    end

  end

    # Find a particular game, based on its name
  def self.search(query, options = Hash.new)
    search_options = {:query => query}
    
    if options.size > 0
      search_options.merge!(options)
    end
    
    puts search_options
    response = get("/search/", :query => search_options)

    item_list = Array.new
    
    if response.code == 200
      xml_data = response.body
      
      doc = REXML::Document.new(xml_data)
      
      doc.elements.each("/items/item") do |item|
        result = SearchResult.new(item.attributes["id"],
                                  item.get_elements("name")[0].attributes["value"],
                                  item.get_elements("yearpublished")[0].attributes["value"],
                                  item.attributes["type"])
        
        item_list << result
      end
    else
      raise response.code
    end
    
    item_list
  end
end

element_list = BggApi.search("Burgund", {:type => 'boardgame'})

element_list.each do |item|
  item.print
end
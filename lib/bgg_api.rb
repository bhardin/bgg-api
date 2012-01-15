require 'httparty'

class BggApi
  include HTTParty
  format :xml

    #base_uri "rubygems.org/api/v1"
  base_uri "www.boardgamegeek.com/xmlapi2"

  attr_accessor :name, :id, :type

  def initialize(name, id, type)
    self.name = name
    self.id = id
    self.type = type
  end

  def self.thing(id)
    response = get("/thing", :query => {:id => id})

    if response.success?
      response["items"]["item"]
    end

  end

    # Find a particular game, based on its name
  def self.search(query)
    response = get("/search/", :query => {:query => query})

    if response.success?
      response["items"]["item"].each do |item|
        self.new(item["name"]["value"], item["id"], item["type"])
      end
    else
      raise response.response
    end
  end
end
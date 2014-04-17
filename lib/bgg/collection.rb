module Bgg
  class Collection
    def self.find_by_username(username)
      if username =~ /^\d*$/
        # this is a sorta hokey restriction because there is probably nothing requiring
        # users to have non-numeric usernames. I'm not sure that I've seen one though.
        raise ArgumentError.new('username must not be empty or only digits!')
      end

      if username.is_a?(Integer)
        raise ArgumentError.new('username must not be an Integer!')
      end

      collection_data = BggApi.collection({username: username})

      unless collection_data.has_key?('item')
        raise ArgumentError.new('User does not exist')
      end

      Bgg::Collection.new(collection_data)
    end
  end

  class Collection
    def initialize(collection_data)
      @items = []

      collection_data['item'].each do |item|
        bgg_item = Bgg::Collection::Item.new(item)
        @items.push(bgg_item)
      end
    end

    def size
      @items.size
    end

    def count
      self.size
    end

    def owned
      @items.select{ |item| item.owned? }
    end

    def boardgames
      @items.select{ |item| item.type == 'boardgame' }
    end

    def boardgame_expansions
      @items.select{ |item| item.name =~ /expansion/i }
    end

    def played
      @items.select{ |item| item.played? }
    end
  end
end

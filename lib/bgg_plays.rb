class BggPlays
  def self.find_by_username(username)
    if username =~ /^\d*$/
      # this is a sorta hokey restriction because there is probably nothing requiring
      # users to have non-numeric usernames. I'm not sure that I've seen one though.
      raise ArgumentError.new('username must not be empty or only digits!')
    end

    if username.is_a?(Integer)
      raise ArgumentError.new('username must not be an Integer!')
    end

    iterator = BggPlaysIterator.new(username)

    iterator.nil? ? nil : iterator
  end

  def self.find_by_id(game_id)
    game_id = Integer(game_id)
    if game_id < 1
      raise ArgumentError.new('game_id must be greater than 0!')
    end

    #game_data = BggApi.thing({id: game_id, type: 'boardgame'})
    #unless game_data.has_key?('item')
      #raise ArgumentError.new('Game does not exist')
    #end
  end
end

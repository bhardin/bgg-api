module Bgg
  class User
    attr_reader :avatar_link, :country, :first_name, :id,
                :last_login, :last_name, :name, :state,
                :year_registered

    def initialize(user_data)
      @id = user_data['id']
      @first_name = user_data['firstname'][0]['value']
      @last_name = user_data['lastname'][0]['value']
      @name = user_data['name']

      @avatar_link = user_data['avatarlink'][0]['value']
      @country = user_data['country'][0]['value']
      @last_login = user_data['lastlogin'][0]['value']
      @state = user_data['stateorprovince'][0]['value']
      @year_registered = user_data['yearregistered'][0]['value']
    end

    def self.find_by_id(user_id)
      user_id = Integer(user_id)
      if user_id < 1
        raise ArgumentError.new('user_id must be greater than zero!')
      end

      user_data = BggApi.user({id: user_id})
      if user_data['id'].empty?
        raise ArgumentError.new('User does not exist')
      end

      Bgg::User.new(user_data)
    end

    def self.find_by_name(user_name)
      if user_name !~ /^\w+$/
        raise ArgumentError.new('find_by_name must be passed a string!')
      end

      user_data = BggApi.user({name: user_name})
      if user_data['id'].empty?
        raise ArgumentError.new('User does not exist')
      end

      Bgg::User.new(user_data)
    end

    def play_count
      some_plays = BggApi.plays({username: self.name, page: 1})
      some_plays.fetch('total', 0).to_i
    end

    def collection
      BggApi.collection(self.name)
    end

    def plays
      Bgg::Plays.find_by_username(self.name)
    end
  end
end

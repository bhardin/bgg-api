module Bgg
	class Play
		attr_reader :date, :game_id, :game_name, :game_type,
			:id, :length, :location, :players, :quantity

		def initialize(play)
			@id = play['id'].to_i
			@incomplete = play['incomplete'].to_i
			@game_id = play['item'][0]['objectid'].to_i
			@length = play['length'].to_i
			@nowinstats = play['nowinstats'].to_i
			@quantity = play['quantity'].to_i

			@game_name = play['item'][0]['name']
			@game_type = play['item'][0]['subtypes'][0]['subtype'][0]['value']

			@date = play['date']
			@location = play['location']

			@players = []
			if play.has_key?('players')
				play['players'][0]['player'].each do |player|
					@players << Player.new(player)
				end
			end
		end

		def nowinstats?
			@nowinstats != 0
		end

		def incomplete?
			@incomplete != 0
		end

		def game
			Bgg::Game.find_by_id(self.game_id)
		end

		class Player
			attr_reader :color, :name, :rating, :score, :start_position, :user_id, :username

			def initialize(player)
				@color = player['color']
				@name = player['name']
				@new = player['new'] == '1'
				@rating = player['rating']
				@score = player['score']
				@start_position = player['startposition']
				@user_id = player['userid']
				@username = player['username']
				@winner = player['win'] == '1'
			end

			def new?
				@new
			end

			def winner?
				@winner
			end
		end
	end
end

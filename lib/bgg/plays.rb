module Bgg
	class Plays
		def self.find_by_username(username)
			if username =~ /^\d*$/
				# this is a sorta hokey restriction because there is probably nothing requiring
				# users to have non-numeric usernames. I'm not sure that I've seen one though.
				raise ArgumentError.new('username must not be empty or only digits!')
			end

			if username.is_a?(Integer)
				raise ArgumentError.new('username must not be an Integer!')
			end

			iterator = Bgg::Plays::Iterator.new(username)

			iterator.nil? ? nil : iterator
		end
	end
end

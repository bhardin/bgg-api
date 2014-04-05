class HashBuilder
  class << self
    def build_basic_game_results(item)
     {
        id:   item['id'].to_i,
        name: item['name'][0]['value'],
        type: item['type'],
      }
    end

    def build_boardgame_by_id(xml, id)
      game_data  = xml['boardgame'][0]

      primary_name = (game_data['name'].find{ |name| name['primary'] == 'true' })['content']

      other_game_names = (game_data['name'].reject { |name| name['primary'] == 'true' }).map { |node| node['content'] }

      return {
          id:    id,
          name:  primary_name,

          age:            game_data['age'][0],
          alternatenames: other_game_names.sort,
          description:    game_data['description'][0],
          image:          game_data['image'][0],
          maxplayers:     game_data['maxplayers'][0],
          minplayers:     game_data['minplayers'][0],
          playingtime:    game_data['playingtime'][0],
          thumbnail:      game_data['thumbnail'][0],
          yearpublished:  game_data['yearpublished'][0],
      }
    end

    def build_players(play, players)
      play['players'][0]['player'].each do |player|
        players << Hash[:name, player['name'], :win, player['win'].to_i, :score, player['score']]
      end
    end

    def build_plays(play, players, plays)
      if players.empty?
        plays << Hash[:date, play['date'], :nowinstats, play['nowinstats'].to_i, :boardgame, play['item'][0]['name'], :objectid, play['item'][0]['objectid'].to_i, :comments, play['comments']]
      else
        plays << Hash[:date, play['date'], :nowinstats, play['nowinstats'].to_i, :boardgame, play['item'][0]['name'], :objectid, play['item'][0]['objectid'].to_i, :players, players, :comments, play['comments']]
      end
    end
  end
end
class HashBuilder
  def self.build_basic_game_results(item, name_result)
    name_result << Hash[:name, item["name"][0]["value"], :type, item["type"],  :id , item["id"].to_i]
  end

  def self.build_complex_boardgame_result(primary_name, alternate_names, xml, id)
    Hash[:id, id, :name, primary_name,:minplayers,xml["boardgame"][0]["minplayers"][0],:maxplayers,xml["boardgame"][0]["maxplayers"][0],
        :age,xml["boardgame"][0]["age"][0], :description, xml["boardgame"][0]["description"][0],:playingtime,xml["boardgame"][0]["playingtime"][0],
        :thumbnail,xml["boardgame"][0]["thumbnail"][0], :image ,xml["boardgame"][0]["image"][0], :alternatenames,  alternate_names.sort,
        :yearpublished,xml["boardgame"][0]["yearpublished"][0] ]
  end

  def self.build_players(play, players)
    play["players"][0]["player"].each do |player|
      players << Hash[:name, player["name"], :win, player["win"].to_i, :score, player["score"]]
    end
  end

  def self.build_plays(play, players, plays)
    plays << Hash[:date, play["date"], :nowinstats, play["nowinstats"].to_i, :boardgame, play["item"][0]["name"], :objectid, play["item"][0]["objectid"].to_i, :players, players, :comments, play["comments"]]
  end
end
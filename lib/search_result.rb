class SearchResult

  @@TYPE_MAP = {
                "boardgame"          => "Board Game",
                "boardgameexpansion" => "Board Game Expansion",
                "rpgitem"            => "Role-playing Game",
                "videogame"          => "Video Game"

               }
  
  attr_accessor :id, :name, :year_published, :type
  
  def initialize(id, name, year_published, type)
    self.id = id
    self.name = name
    self.year_published = year_published
    self.type = @@TYPE_MAP[type]
  end
  
  def print
    puts "Title: #{self.name}, ID: #{self.id}, Type: #{self.type}, Year published: #{self.year_published}"
  end
end

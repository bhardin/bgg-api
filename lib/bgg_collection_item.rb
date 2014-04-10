class BggCollectionItem
  attr_reader :collection_id, :comment, :id, :image, :name,
              :play_count, :thumbnail, :type, :year_published


  def initialize(item)
    # Integers
    @id = item['objectid'].to_i
    @collection_id = item['collid'].to_i
    @play_count = item['numplays'][0].to_i

    @comment = item.fetch('comment', [])[0]
    @image = item['image'][0]
    @name = item['name'][0]['content']
    @thumbnail = item['thumbnail'][0]
    @type = item['subtype']

    # booleans
    @owned = item['status'][0]['own'] == '1'
    @for_trade = item['status'][0]['fortrade'] == '1'
    @preordered = item['status'][0]['preordered'] == '1'
    @want_to_buy = item['status'][0]['wanttobuy'] == '1'
    @want_to_play = item['status'][0]['wanttoplay'] == '1'
    @wanted = item['status'][0]['want'] == '1'

    # special handling
    @year_published = item.fetch('yearpublished', ['0'])[0].to_i
  end

  def played?
    @play_count > 0
  end

  def wanted?
    @wanted
  end

  def for_trade?
    @for_trade
  end

  def owned?
    @owned
  end

  def want_to_play?
    @want_to_play
  end

  def want_to_buy?
    @want_to_buy
  end

  def preordered?
    @preordered
  end

  def published?
    @year_published != 0
  end

  def game
    BggGame.find_by_id(self.id)
  end
end

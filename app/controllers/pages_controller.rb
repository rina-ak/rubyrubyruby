class PagesController < ApplicationController
  COLLECTIONS = [
    {
      slug: "noughties",
      eyebrow: "Новая подборка",
      title: "Как звучали и выглядели нулевые",
      summary: "Поп-культура, глянец, компакт-диски и ночные города. Музыка эпохи, в которой будущее казалось совсем близким.",
      image: "home/noughties.png",
      hero: "home/collection-hero.png",
      tags: ["Поп-культура", "Глянец", "CD", "Клубная сцена"],
      era: "2000–2009",
      curator_title: "Время, когда музыка была вещью",
      curator: "Нулевые — это музыка на экранах телевизоров, компакт-диски с любимыми альбомами, первые MP3-плееры, клубная культура, глянцевые журналы и ощущение, что впереди — только большое. Это десятилетие, где поп-культура, технологии и городская жизнь сплелись в новый, узнаваемый стиль.",
      keywords: %w[y2k ностальг k-pop 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 нулев]
    },
    {
      slug: "confession",
      eyebrow: "Личное / тексты",
      title: "Песня как исповедь",
      summary: "Альбомы, в которых личный опыт становится цельным художественным миром: от тихого признания до почти трагического сюжета.",
      image: "home/confession.png",
      hero: "home/confession.png",
      tags: ["Личное / тексты"],
      era: nil,
      curator_title: nil,
      curator: nil,
      keywords: %w[память меланхол давлен изоляц фолк личн]
    },
    {
      slug: "america",
      eyebrow: "Культурный контекст",
      title: "Америка, которой не было",
      summary: "Придуманные города, мотели, религиозные образы и разрушенная американская мечта в музыке.",
      image: "home/america.png",
      hero: "home/america.png",
      tags: ["Культурный контекст"],
      era: nil,
      curator_title: nil,
      curator: nil,
      keywords: %w[квир баллрум метавсел освобожд американ]
    },
    {
      slug: "cities",
      eyebrow: "Город / звучание",
      title: "Города после полуночи",
      summary: "Постпанк, дрим-поп и холодная электроника — музыка пустых улиц, дальних поездок и света из окон.",
      image: "home/cities.png",
      hero: "home/cities.png",
      tags: ["Город / звучание"],
      era: nil,
      curator_title: nil,
      curator: nil,
      keywords: %w[граффити киберпанк фламенко хоррор город постпанк]
    },
    {
      slug: "quiet",
      eyebrow: "Настроение",
      title: "Тише, чем поп-музыка",
      summary: "Инди-фолк и камерный поп для внимательного слушания: голос, пауза, акустика и личные истории.",
      image: "home/quiet.png",
      hero: "home/quiet.png",
      tags: ["Настроение"],
      era: nil,
      curator_title: nil,
      curator: nil,
      keywords: %w[фолк лоуфай память меланхол чёрно камер]
    }
  ].freeze

  def home
    @albums = Album.all
    @featured = self.class.featured_collection
    render layout: "album"
  end

  def self.featured_collection
    present_collection(COLLECTIONS.first)
  end

  def collections
    @featured = self.class.featured_collection
    @collections = COLLECTIONS.drop(1).map { |item| self.class.present_collection(item) }
    @inside = Album.order(year: :desc).limit(4)
    render layout: "album"
  end

  def collection
    raw = COLLECTIONS.find { |item| item[:slug] == params[:slug] }
    return redirect_to(collections_path) unless raw

    @collection = self.class.present_collection(raw)
    render :collection_show, layout: "album"
  end

  def about
    render layout: "album"
  end

  def teaser
    render layout: "teaser"
  end

  def privacy
    render layout: "teaser"
  end

  def self.present_collection(item)
    albums = Album.all.select { |album| collection_match?(album, item) }
    item.merge(albums: albums, count: albums.size)
  end

  def self.collection_match?(album, item)
    blob = [
      album.title, album.artist, album.genre, album.mood,
      album.visual_language, album.cultural_context, album.year
    ].join(" ").downcase
    item[:keywords].any? { |word| blob.include?(word) }
  end
end

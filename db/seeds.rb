require 'open-uri'
require 'fileutils'
require 'tempfile'
require 'zlib'

@raw_text = 'Музыкальный альбом как концептуальное высказывание объединяет графический дизайн типографику и аудиальный нарратив. Звучание синтезаторов и аналоговых драм-машин создает аутентичную текстуру звука. Визуальный код обложки транслирует эстетику клубной культуры деконструкции и минимализма. Критики отмечают влияние гиперпопа глитча и лоуфай продакшена на современную сцену.'
@words = @raw_text.downcase.gsub(/[—.—,«»:()]/, '').gsub(/  /, ' ').split(' ')

PLACEHOLDER_COVER_URL = 'https://picsum.photos/600/600'
COVER_OPEN_OPTIONS = {
  'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
  open_timeout: 5,
  read_timeout: 10
}.freeze

def seed
  prepare_uploads
  clean_db
  create_users
  create_curated_albums
  assign_release_metadata
  create_comments
  puts "База данных успешно засеяна альбомами с обложками и текстами!"
end

def prepare_uploads
  dir = Rails.root.join('public/uploads')
  FileUtils.mkdir_p(dir)
  FileUtils.chmod(0o755, dir)
end

def clean_db
  puts "Очистка базы данных..."
  Comment.destroy_all
  AlbumProposal.destroy_all
  ThematicSection.destroy_all
  Album.destroy_all
  User.destroy_all
  reset_sqlite_sequence
end

def reset_sqlite_sequence
  return unless ActiveRecord::Base.connection.adapter_name.match?(/sqlite/i)

  ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence")
  puts "Счётчик sqlite_sequence сброшен, ID начнутся с 1"
end

def create_sentence(min_words = 6, max_words = 12)
  sentence_words = []
  (min_words..max_words).to_a.sample.times { sentence_words << @words.sample }
  sentence_words.join(' ').capitalize + '.'
end

def create_users
  puts "Создание пользователей..."
  admin_password = ENV.fetch('ADMIN_PASSWORD') { Rails.env.development? ? 'password123' : raise('ADMIN_PASSWORD is required to seed outside development') }
  User.create!(
    email: 'admin@decode.media',
    password: admin_password,
    password_confirmation: admin_password,
    admin: true,
    role: 'admin'
  )
  3.times do |i|
    User.create!(
      email: "user#{i + 1}@decode.media",
      password: 'password123',
      password_confirmation: 'password123',
      admin: false,
      role: 'user'
    )
  end
end

def attach_remote_cover(album, image_url)
  file = download_image(image_url) || download_image(PLACEHOLDER_COVER_URL) || local_placeholder(album)
  album.cover = file
  album.save!
  puts "Обложка прикреплена: #{album.title} -> #{album.cover.url}"
ensure
  file.close! if defined?(file) && file.is_a?(Tempfile)
end

def download_image(url)
  io = nil
  io = URI.open(url, COVER_OPEN_OPTIONS)
  content_type = io.content_type.to_s.split(';').first
  raise "unexpected content type #{content_type.inspect}" unless content_type.start_with?('image/')

  ext = extension_for(content_type, io.base_uri.to_s)
  tempfile = Tempfile.new([ 'cover', ".#{ext}" ])
  tempfile.binmode
  IO.copy_stream(io, tempfile)
  tempfile.rewind
  raise 'empty image' if tempfile.size.zero?

  filename = "cover.#{ext}"
  tempfile.define_singleton_method(:original_filename) { filename }
  tempfile.define_singleton_method(:content_type) { content_type }
  tempfile
rescue => e
  puts "Не удалось скачать #{url}: #{e.class}: #{e.message}"
  tempfile.close! if defined?(tempfile) && tempfile.is_a?(Tempfile)
  nil
ensure
  io&.close
end

def extension_for(content_type, url)
  mapped = {
    'image/jpeg' => 'jpg',
    'image/png' => 'png',
    'image/gif' => 'gif',
    'image/webp' => 'webp'
  }[content_type]
  return mapped if mapped

  ext = File.extname(URI.parse(url).path).delete_prefix('.').downcase
  %w[jpg jpeg gif png webp].include?(ext) ? ext : 'jpg'
end

def local_placeholder(album)
  puts "Локальная заглушка для #{album.title}"
  palette = [
    [ 198, 242, 73 ],
    [ 244, 180, 196 ],
    [ 36, 36, 36 ],
    [ 212, 175, 55 ],
    [ 30, 58, 95 ],
    [ 196, 48, 68 ]
  ]
  color = palette[album.id.to_i % palette.size]
  tempfile = Tempfile.new([ 'cover', '.png' ])
  tempfile.binmode
  tempfile.write(solid_png(600, 600, *color))
  tempfile.rewind
  tempfile.define_singleton_method(:original_filename) { 'cover.png' }
  tempfile.define_singleton_method(:content_type) { 'image/png' }
  tempfile
end

def solid_png(width, height, red, green, blue)
  scanlines = Array.new(height) { "\x00".b + ([ red, green, blue ].pack('C*') * width) }.join
  ihdr = [ width, height, 8, 2, 0, 0, 0 ].pack('NNCCCCC')
  idat = Zlib::Deflate.deflate(scanlines)
  signature = "\x89PNG\r\n\x1A\n".b
  signature + png_chunk('IHDR', ihdr) + png_chunk('IDAT', idat) + png_chunk('IEND', '')
end

def png_chunk(type, data)
  [ data.bytesize ].pack('N') + type + data + [ Zlib.crc32(type + data) ].pack('N')
end

def create_curated_albums
  puts "Создание концептуальных альбомов..."

  curated = [
    {
      title: 'BRAT',
      artist: 'Charli xcx',
      genre: 'Hyperpop / Club',
      year: 2024,
      mood: 'сестринство',
      visual_language: 'кислотный глянец',
      cultural_context: 'клубная культура',
      cover_url: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/6/60/Charli_XCX_-_Brat_%28album_cover%29.png/1280px-Charli_XCX_-_Brat_%28album_cover%29.png',
      description: '«BRAT» — манифест клубной деконструкции и главный культурный код сезона. Обложка с намеренно «грязным» кислотно-лаймовым фоном и пиксельным шрифтом Arial.'
    },
    {
      title: 'Get Up',
      artist: 'NewJeans',
      genre: 'UK Garage / K-Pop',
      year: 2023,
      mood: 'ностальгия',
      visual_language: 'Y2K',
      cultural_context: 'k-pop',
      cover_url: 'https://upload.wikimedia.org/wikipedia/en/e/ee/NewJeans_-_Get_Up.png',
      description: 'Мини-альбом «Get Up» переосмысляет визуальную ностальгию эпохи Y2K через призму современного векторного дизайна.',
      duration: '12:08',
      release_type: 'Мини-альбом',
      sections: [
        { section_type: 'about', title: 'Об альбоме', content: '' },
        { section_type: 'history', title: 'История создания', content: '' },
        { section_type: 'sound', title: 'Звучание', content: '' },
        { section_type: 'stories', title: 'Персонажи и сюжеты', content: '' },
        { section_type: 'visual', title: 'Визуальный язык', content: '' },
        { section_type: 'materials', title: 'Материалы', content: '' },
        { section_type: 'explore', title: 'Продолжить исследование', content: '' },
        { section_type: 'sources', title: 'Источники', content: '' }
      ]
    },
    {
      title: 'Armageddon',
      artist: 'aespa',
      genre: 'Art Pop / Cyberpunk',
      year: 2024,
      mood: 'хоррор',
      visual_language: 'киберпанк',
      cultural_context: 'метавселенная',
      cover_url: 'https://upload.wikimedia.org/wikipedia/en/8/8e/Aespa_-_Armageddon.jpg',
      description: 'Полноформатный релиз «Armageddon» развивает футуристическую метавселенную в сторону мрачного научно-фантастического хоррора.'
    },
    {
      title: 'RENAISSANCE',
      artist: 'Beyoncé',
      genre: 'House / Ballroom',
      year: 2022,
      mood: 'освобождение',
      visual_language: 'баллрум',
      cultural_context: 'квир-история',
      cover_url: 'https://upload.wikimedia.org/wikipedia/en/a/ad/Beyonc%C3%A9_-_Renaissance.png',
      description: '«RENAISSANCE» — ода квир-истории афроамериканского хауса, баллрум-культуры и диско 70-х.'
    },
    {
      title: 'Heaven Knows',
      artist: 'PinkPantheress',
      genre: 'Drum and Bass / Bedroom Pop',
      year: 2023,
      mood: 'меланхолия',
      visual_language: 'викторианская готика',
      cultural_context: 'лоуфай',
      cover_url: 'https://upload.wikimedia.org/wikipedia/en/2/20/PinkPantheress_-_Heaven_Knows.png',
      description: 'Дебютный лонгплей PinkPantheress переносит интимную эстетику лоуфай-бедрум-попа в формат винтажного драм-н-бэйса.'
    },
    {
      title: 'MOTOMAMI',
      artist: 'Rosalía',
      genre: 'Avant-Pop / Reggaeton',
      year: 2022,
      mood: 'двойственность',
      visual_language: 'граффити',
      cultural_context: 'фламенко',
      cover_url: 'https://upload.wikimedia.org/wikipedia/en/9/9c/Rosal%C3%ADa_-_Motomami.png',
      description: 'Двойственная концепция альбома разделена на агрессивную энергию «MOTO» и уязвимую «MAMI».'
    },
    {
      title: 'petal',
      artist: 'Ariana Grande',
      genre: 'Dark Pop / Synth-Pop / Alt-Pop',
      year: 2026,
      duration: '36:08',
      release_type: 'Студийный альбом',
      mood: 'давление',
      visual_language: 'цветы на асфальте',
      cultural_context: 'парасоциальные отношения',
      cover_url: 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e3/Petal_by_Ariana_Grande.png/600px-Petal_by_Ariana_Grande.png',
      description: 'Восьмой студийный альбом Арианы Гранде. Метафора цветка, прорастающего сквозь холодный асфальт.',
      sections: [
        { section_type: 'history', title: 'История создания и концепт', content: 'Альбом родился в период между съёмками мюзикла «Wicked» и туром The Eternal Sunshine Tour.' },
        { section_type: 'visual', title: 'Визуальный язык и эстетика', content: 'Контраст хрупкости и урбанистической брутальности.' },
        { section_type: 'musical', title: 'Звучание и продакшн', content: 'Синтез дарк-попа, плотных аналоговых синтов и инди-рока.' },
        { section_type: 'culture', title: 'Культурный контекст и мета-нарратив', content: 'Деконструкция парасоциальных отношений и публичного образа поп-дивы.' }
      ]
    },
    {
      title: 'folklore',
      artist: 'Taylor Swift',
      genre: 'Инди-фолк / Чембер-поп',
      year: 2020,
      cover_url: 'https://upload.wikimedia.org/wikipedia/en/f/f8/Taylor_Swift_-_Folklore.png',
      description: 'Неожиданный переход от стадионного попа к интимному акустическому сторителлингу в разгар локдауна.'
    }
  ]

  curated.each do |item|
    album = Album.create!(
      title: item[:title],
      artist: item[:artist],
      genre: item[:genre],
      year: item[:year],
      duration: item[:duration],
      release_type: item[:release_type],
      mood: item[:mood],
      visual_language: item[:visual_language],
      cultural_context: item[:cultural_context],
      cover_url: item[:cover_url],
      description: item[:description]
    )
    Array(item[:sections]).each { |section| album.thematic_sections.create!(section) }
    attach_remote_cover(album, item[:cover_url])
  end
end

def create_comments
  puts "Создание комментариев..."
  users = User.all.to_a
  Album.all.each do |album|
    rand(2..4).times do
      album.comments.create!(
        body: create_sentence(5, 12),
        user: users.sample
      )
    end
  end
end

def assign_release_metadata
  types = ["LP", "EP", "Single", "LP"]
  durations = ["42:15", "19:40", "38:50", "51:02", "24:10"]

  Album.find_each.with_index do |album, index|
    album.update(
      release_type: album.release_type.presence || types[index % types.size],
      duration: album.duration.presence || durations[index % durations.size]
    )
  end
end

seed
require 'open-uri'

@raw_text = 'Музыкальный альбом как концептуальное высказывание объединяет графический дизайн типографику и аудиальный нарратив. Звучание синтезаторов и аналоговых драм-машин создает аутентичную текстуру звука. Визуальный код обложки транслирует эстетику клубной культуры деконструкции и минимализма. Критики отмечают влияние гиперпопа глитча и лоуфай продакшена на современную сцену.'
@words = @raw_text.downcase.gsub(/[—.—,«»:()]/, '').gsub(/  /, ' ').split(' ')

def seed
  clean_db
  create_users
  create_curated_albums
  create_comments
  puts "База данных успешно засеяна альбомами с обложками и текстами!"
end

def clean_db
  puts "Очистка базы данных..."
  Comment.destroy_all
  Album.destroy_all
  User.destroy_all
end

def create_sentence(min_words = 6, max_words = 12)
  sentence_words = []
  (min_words..max_words).to_a.sample.times { sentence_words << @words.sample }
  sentence_words.join(' ').capitalize + '.'
end

def create_users
  puts "Создание пользователей..."
  User.create!(
    email: 'admin@decode.media',
    password: 'password123',
    password_confirmation: 'password123',
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
  # Передаем реальный браузерный User-Agent, чтобы Википедия отдала картинку
  downloaded_image = URI.parse(image_url).open(
    "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
  )
  album.cover = downloaded_image
  album.save!
  puts "Обложка прикреплена: #{album.title}"
rescue => e
  puts "Не удалось загрузить обложку для #{album.title}: #{e.message}"
end

def create_curated_albums
  puts "Создание концептуальных альбомов..."

  curated = [
    {
      title: 'BRAT',
      artist: 'Charli xcx',
      genre: 'Hyperpop / Club',
      year: 2024,
      cover_url: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/6/60/Charli_XCX_-_Brat_%28album_cover%29.png/1280px-Charli_XCX_-_Brat_%28album_cover%29.png?utm_source=en.wikipedia.org&utm_campaign=index&utm_content=thumbnail',
      description: '«BRAT» — манифест клубной деконструкции и главный культурный код сезона. Обложка с намеренно «грязным» кислотно-лаймовым фоном (Pantone 3570-C) и пиксельным, слегка размытым шрифтом Arial стала антитезой вылизанному глянцевому дизайну поп-индустрии. Музыкально релиз соединяет агрессивный рейв-электро-клэш с уязвимыми текстами о сестринстве, женской зависти и выгорании.'
    },
    {
      title: 'Get Up',
      artist: 'NewJeans',
      genre: 'UK Garage / K-Pop',
      year: 2023,
      cover_url: 'https://upload.wikimedia.org/wikipedia/en/e/ee/NewJeans_-_Get_Up.png?utm_source=en.wikipedia.org&utm_campaign=imageinfo&utm_content=thumbnail_unscaled',
      description: 'Мини-альбом «Get Up» переосмысляет визуальную ностальгию эпохи Y2K через призму современного векторного дизайна. Коллаборация с культовым шоу The Powerpuff Girls подарила каждой участнице 2D-аватар, ставший ключевым элементом айдентики релиза. Звучание альбома держится на невесомом UK Garage, джерси-клабе и минималистичных вокальных хуках.'
    },
    {
      title: 'Armageddon',
      artist: 'aespa',
      genre: 'Art Pop / Cyberpunk',
      year: 2024,
      cover_url: 'https://upload.wikimedia.org/wikipedia/en/8/8e/Aespa_-_Armageddon.jpg?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail_unscaled',
      description: 'Полноформатный релиз «Armageddon» развивает футуристическую метавселенную группы в сторону мрачного научно-фантастического хоррора и биомеханики. Визуальный язык проекта отсылает к эстетике киберпанка конца 90-х и хромированным 3D-текстурам. В треках доминируют перегруженные синтезаторные басы, индустриальный хип-хоп и драматичные многоголосные бриджи.'
    },
    {
      title: 'RENAISSANCE',
      artist: 'Beyoncé',
      genre: 'House / Ballroom',
      year: 2022,
      cover_url: 'https://upload.wikimedia.org/wikipedia/en/a/ad/Beyonc%C3%A9_-_Renaissance.png?utm_source=en.wikipedia.org&utm_campaign=imageinfo&utm_content=thumbnail_unscaled',
      description: '«RENAISSANCE» — ода квир-истории афроамериканского хауса, баллрум-культуры и диско 70-х. Монументальный снимок Бейонсе на сверкающем стеклянном коне (отсылка к Леди Годиве и легендарному клубу Studio 54) задал эстетический тон всей эре. Альбом представляет собой бесшовный часовой диджей-сет с безупречным звуковым продакшеном.'
    },
    {
      title: 'Heaven Knows',
      artist: 'PinkPantheress',
      genre: 'Drum and Bass / Bedroom Pop',
      year: 2023,
      cover_url: 'https://upload.wikimedia.org/wikipedia/en/2/20/PinkPantheress_-_Heaven_Knows.png?utm_source=en.wikipedia.org&utm_campaign=imageinfo&utm_content=thumbnail_unscaled',
      description: 'Дебютный лонгплей PinkPantheress переносит интимную эстетику лоуфай-бедрум-попа в формат винтажного драм-н-бэйса и тустеп-гэриджа. Готический викторианский визуал обложки в приглушенных синих тонах контрастирует со стремительным электронным брейкбитом и меланхоличным, почти шепчущим вокалом.'
    },
    {
      title: 'MOTOMAMI',
      artist: 'Rosalía',
      genre: 'Avant-Pop / Reggaeton',
      year: 2022,
      cover_url: 'https://upload.wikimedia.org/wikipedia/en/9/9c/Rosal%C3%ADa_-_Motomami.png?utm_source=en.wikipedia.org&utm_campaign=imageinfo&utm_content=thumbnail_unscaled',
      description: 'Двойственная концепция альбома разделена на агрессивную, маскулинную энергию «MOTO» и уязвимую, нежную «MAMI». Обложка в стиле спонтанного граффити подчеркивает сырость и бескомпромиссность релиза. В трек-листе классическое фламенко деконструируется и сталкивается с агрессивным дембоу, индастриалом и автотюном.'
    }
  ]

  curated.each do |item|
    album = Album.create!(
      title: item[:title],
      artist: item[:artist],
      genre: item[:genre],
      year: item[:year],
      description: item[:description]
    )
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

seed

@raw_text = 'Музыкальный альбом как концептуальное высказывание эпохи постмодерна объединяет графический дизайн типографику и аудиальный нарратив. Звучание синтезаторов и аналоговых драм-машин создает аутентичную текстуру звука. Визуальный код обложки транслирует эстетику клубной культуры деконструкции и минимализма. Критики отмечают влияние гиперпопа глитча и лоуфай продакшена на современную инди сцену. Эксперименты с ритмическими паттернами и перегруженным вокалом формируют новый манифест поколения.'
@words = @raw_text.downcase.gsub(/[—.—,«»:()]/, '').gsub(/  /, ' ').split(' ')

@artists = [
  'Charli xcx', 'aespa', 'NewJeans', 'Beyoncé', 'PinkPantheress', 
  'Rosalía', 'FKA twigs', 'Yves Tumor', 'Frank Ocean', 'Kendrick Lamar'
]

@album_titles = [
  'BRAT', 'Armageddon', 'Get Up', 'RENAISSANCE', 'Heaven Knows',
  'MOTOMAMI', 'CAPRISONGS', 'Heaven to a Tortured Mind', 'Blonde', 'GNX'
]

def seed
  clean_db
  create_users
  create_albums
  create_comments
  puts " База данных успешно засеяна данными decode!"
end

def clean_db
  puts "Очистка базы данных..."
  Comment.destroy_all
  Album.destroy_all
  User.destroy_all
end

def create_sentence(min_words = 6, max_words = 12)
  sentence_words = []
  (min_words..max_words).to_a.sample.times do
    sentence_words << @words.sample
  end
  sentence_words.join(' ').capitalize + '.'
end

def create_users
  puts "Создание пользователей..."
  
  # админ
  admin = User.create!(
    email: 'admin@decode.media',
    password: 'password123',
    password_confirmation: 'password123',
    admin: true,
    role: 'admin'
  )
  puts "Создан администратор: #{admin.email} (пароль: password123)"

  # обычные пользователи
  4.times do |i|
    u = User.create!(
      email: "user#{i + 1}@decode.media",
      password: 'password123',
      password_confirmation: 'password123',
      admin: false,
      role: 'user'
    )
    puts "Создан пользователь: #{u.email}"
  end
end

def create_albums
  puts "Создание альбомов..."
  @album_titles.each_with_index do |title, index|
    artist = @artists[index] || @artists.sample

    album_data = {
      title: title,
      artist: artist
    }
    album_data[:description] = create_sentence(10, 20) if Album.column_names.include?('description')
    album_data[:year] = rand(2018..2026) if Album.column_names.include?('year')
    album_data[:genre] = ['Electronic', 'Hyperpop', 'R&B', 'Art Pop', 'Hip-Hop'].sample if Album.column_names.include?('genre')

    album = Album.create!(album_data)
    puts "Альбом: #{album.title} — #{album.artist}"
  end
end

def create_comments
  puts "Создание комментариев..."
  Album.all.each do |album|
    rand(2..5).times do
      album.comments.create!(
        body: create_sentence(4, 10)
      )
    end
  end
  puts "Комментарии успешно привязаны ко всем альбомам."
end

seed

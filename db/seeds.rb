puts "Очищаем базу данных перед наполнением..."
Album.destroy_all
puts "База очищена!"

albums_data = [
  {
    title: "folklore",
    artist: "Taylor Swift",
    release_year: 2020,
    duration: "63:29",
    release_type: "Студийный альбом",
    genre: "Инди-фолк / Чембер-поп",
    cover_url: "https://upload.wikimedia.org/wikipedia/en/f/f8/Taylor_Swift_-_Folklore.png",
    intro_text: "Неожиданный переход от стадионного попа к интимному акустическому сторителлингу. Записанный в разгар локдауна, folklore исследует эскапизм, чужие вымышленные биографии и меланхоличную пасторальную эстетику cottagecore.",
    sections: [
      { section_type: "history", title: "История создания", content: "Альбом родился в изоляции весной 2020 года при дистанционном соавторстве с Аароном Десснером." },
      { section_type: "visual", title: "Визуальный язык", content: "Черно-белая зернистая эстетика лесов Пенсильвании, уютные кардиганы и туман." },
      { section_type: "musical", title: "Музыкальные влияния", content: "Звучание инди-рока, Bon Iver, акустические гитары и мягкое фортепиано." },
      { section_type: "culture", title: "Культурные отсылки", content: "Главный катализатор расцвета эстетики cottagecore в соцсетях начала 2020-х." }
    ]
  },
  {
    title: "OMG",
    artist: "NewJeans",
    release_year: 2023,
    duration: "06:32",
    release_type: "Сингл-альбом",
    genre: "K-pop / R&B / UK Garage",
    cover_url: "https://upload.wikimedia.org/wikipedia/en/1/10/NewJeans_OMG_cover.jpg",
    intro_text: "Сингл-альбом, закрепивший NewJeans в статусе трендсеттеров поколения: сочетание ностальгического Y2K R&B, джерси-клаба и мета-рефлексии о кумирах и фанатах.",
    sections: [
      { section_type: "history", title: "История создания", content: "Продолжение дебютной концепции Мин Хиджин, раскрывающее эмоциональную уязвимость подростков." },
      { section_type: "visual", title: "Визуальный язык", content: "Режиссура Шин Усока: сюрреалистичная клиника, кроличьи мотивы и деконструкция айдол-культуры." },
      { section_type: "musical", title: "Музыкальные влияния", content: "Плавный синтез Baltimore club, брейкбита и уличного R&B нулевых." },
      { section_type: "culture", title: "Культурные отсылки", content: "Отсылки к фильму 'Я киборг, но это нормально' Пака Чхан Ука и волна глобального ретровейва." }
    ]
  },
  {
    title: "Blurryface",
    artist: "Twenty One Pilots",
    release_year: 2015,
    duration: "52:23",
    release_type: "Студийный альбом",
    genre: "Альтернативный рок / Синти-поп",
    cover_url: "https://upload.wikimedia.org/wikipedia/en/7/7d/Blurryface_by_Twenty_One_Pilots.png",
    intro_text: "Концептуальный альбом, где вымышленный персонаж Blurryface олицетворяет внутренние страхи, неуверенность и ментальные барьеры вокалиста Тайлера Джозефа.",
    sections: [
      { section_type: "history", title: "История создания", content: "Эпоха прорыва дуэта из локальных клубов Огайо на стадионы по всему миру." },
      { section_type: "visual", title: "Визуальный язык", content: "Черно-красно-белая концептуальная палитра и девять графических паттернов на обложке." },
      { section_type: "musical", title: "Музыкальные влияния", content: "Гибрид инди-попа, регги, хип-хоп речитатива и партии укулеле." },
      { section_type: "culture", title: "Культурные отсылки", content: "Зарождение многолетней сюжетной вселенной города Демы (Dema)." }
    ]
  },
  {
    title: "Blessed & Possessed",
    artist: "Powerwolf",
    release_year: 2015,
    duration: "45:34",
    release_type: "Студийный альбом",
    genre: "Пауэр-метал / Хэви-метал",
    cover_url: "https://upload.wikimedia.org/wikipedia/en/8/81/Powerwolf_-_Blessed_%26_Possessed.jpg",
    intro_text: "Эпический метал-опус, замешанный на оперном вокале Аттилы Дорна, мифологии оборотней и католической хоровой традиции.",
    sections: [
      { section_type: "history", title: "История создания", content: "Запись в Studio Fredman, закрепившая статус группы как хедлайнеров европейских фестивалей." },
      { section_type: "visual", title: "Визуальный язык", content: "Готический грим корпспэйнт, средневековые рясы и церковная сценография." },
      { section_type: "musical", title: "Музыкальные влияния", content: "Скоростные гитарные риффы, церковный орган и монументальный мужской хор." },
      { section_type: "culture", title: "Культурные отсылки", content: "Пародийно-серьезное обыгрывание средневековых латинских молитв и бестиариев." }
    ]
  }
]

albums_data.each do |data|
  sections = data.delete(:sections)
  album = Album.create!(data)
  
  sections.each do |sec|
    album.thematic_sections.create!(sec)
  end

  puts "Альбом '#{album.title}' (#{album.artist}) успешно создан! ID: #{album.id}"
end

puts "\nБаза успешно наполнена альбомами и разделами!"
class Album < ApplicationRecord
  mount_uploader :cover, CoverUploader

  validates :title, :artist, presence: true

  # Новые фильтры каталога добавляются сюда.
  # source — поле альбома. Значения через « / » попадают в аккордеон сами,
  # как только они есть у любой записи. Для нового фильтра добавьте строку
  # и колонку (или используйте уже существующее поле).
  CATALOG_FILTERS = [
    { key: "genre", label: "Жанр", source: :genre },
    { key: "year", label: "Эпоха", source: :year },
    { key: "mood", label: "Настроение", source: :mood },
    { key: "visual", label: "Визуальный язык", source: :visual_language },
    { key: "context", label: "Культурный контекст", source: :cultural_context }
  ].freeze

  def self.search(query)
    term = query.to_s.strip
    return none if term.blank?

    pattern = "%#{sanitize_sql_like(term)}%"
    where(
      "title LIKE :q OR artist LIKE :q OR genre LIKE :q OR mood LIKE :q OR visual_language LIKE :q OR cultural_context LIKE :q OR CAST(year AS TEXT) LIKE :q",
      q: pattern
    )
  end

  def self.catalog_filter_groups
    CATALOG_FILTERS.map do |filter|
      options = all.flat_map { |album| album.catalog_values(filter[:source]) }.uniq
      options = filter[:source] == :year ? options.sort.reverse : options.sort
      filter.merge(options: options)
    end
  end

  def catalog_values(attribute)
    public_send(attribute).to_s.split(%r{\s*/\s*}).map(&:strip).compact_blank
  end

  def folklore?
    title.to_s.casecmp("folklore").zero? && artist.to_s.casecmp("Taylor Swift").zero?
  end

  def get_up?
    title.to_s.casecmp("Get Up").zero? && artist.to_s.casecmp("NewJeans").zero?
  end

  def dossier_template
    return "albums/show_folklore" if folklore?
    return "albums/show_get_up" if get_up?

    "albums/show_placeholder"
  end

  has_many :thematic_sections, dependent: :destroy
  has_many :comments, dependent: :destroy
end

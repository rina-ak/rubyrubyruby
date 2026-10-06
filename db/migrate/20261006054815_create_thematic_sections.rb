class CreateThematicSections < ActiveRecord::Migration[8.1]
  def change
    create_table :thematic_sections do |t|
      t.string :section_type
      t.string :title
      t.text :content
      t.references :album, null: false, foreign_key: true

      t.timestamps
    end
  end
end

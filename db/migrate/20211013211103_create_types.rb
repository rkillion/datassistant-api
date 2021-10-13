class CreateTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :types do |t|
      t.belongs_to :datassistant, null: false, foreign_key: true
      t.string :title_singular
      t.string :title_plural

      t.timestamps
    end
  end
end

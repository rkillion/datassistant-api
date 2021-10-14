class CreateBaseTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :base_types do |t|
      t.string :title_singular
      t.string :title_plural
      t.string :value_type

      t.timestamps
    end
  end
end

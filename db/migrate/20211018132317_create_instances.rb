class CreateInstances < ActiveRecord::Migration[6.1]
  def change
    create_table :instances do |t|
      t.string :name
      t.belongs_to :datassistant, null: false, foreign_key: true

      t.timestamps
    end
  end
end

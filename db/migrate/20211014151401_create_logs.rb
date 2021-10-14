class CreateLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :logs do |t|
      t.text :note
      t.string :action
      t.string :relationship
      t.integer :type_a_id
      t.integer :type_b_id
      t.belongs_to :datassistant, null: false, foreign_key: true

      t.timestamps
    end
  end
end

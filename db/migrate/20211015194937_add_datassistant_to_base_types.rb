class AddDatassistantToBaseTypes < ActiveRecord::Migration[6.1]
  def change
    add_column :base_types, :datassistant_id, :integer
  end
end

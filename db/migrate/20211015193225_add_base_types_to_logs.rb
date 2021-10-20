class AddBaseTypesToLogs < ActiveRecord::Migration[6.1]
  def change
    add_column :logs, :base_type_a_id, :integer
    add_column :logs, :base_type_b_id, :integer
  end
end

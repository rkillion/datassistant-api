class AddInstancesToLogs < ActiveRecord::Migration[6.1]
  def change
    add_column :logs, :instance_a_id, :integer
    add_column :logs, :instance_b_id, :integer
  end
end

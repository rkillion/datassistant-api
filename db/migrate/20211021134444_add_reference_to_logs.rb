class AddReferenceToLogs < ActiveRecord::Migration[6.1]
  def change
    add_column :logs, :reference, :string
  end
end

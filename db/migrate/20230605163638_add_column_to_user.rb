class AddColumnToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :mentor, :boolean
  end
end

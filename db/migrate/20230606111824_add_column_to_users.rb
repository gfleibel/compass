class AddColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :field_of_work, :string
  end
end

class AddColumnToMatch < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :matched, :boolean
  end
end

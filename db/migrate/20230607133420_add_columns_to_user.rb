class AddColumnsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :about_me, :text
    add_column :users, :professional_about, :text
    add_column :users, :transition_about, :text
  end
end

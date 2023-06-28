class AddUniqueIndexToUsersGithub < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :github, unique: true
  end
end

class AddGithubUniquenessToUser < ActiveRecord::Migration[7.0]
  def change
    remove_index :users, name: "index_users_on_github"
    add_index :users, :github, name: "index_users_on_github", unique: true, where: "github IS NOT NULL AND github != ''"
  end
end

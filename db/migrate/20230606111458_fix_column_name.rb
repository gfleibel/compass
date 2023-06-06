class FixColumnName < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :mentor_transition_date, :string
    rename_column :users, :mentor_transition_date, :years_of_experience
  end
end

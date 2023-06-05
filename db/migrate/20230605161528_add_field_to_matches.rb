class AddFieldToMatches < ActiveRecord::Migration[7.0]
  def change
    change_table(:matches) do |t|
      t.references :mentor, foreign_key: { to_table: 'users' }
      t.references :mentee, foreign_key: { to_table: 'users' }
    end
  end
end

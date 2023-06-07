class SetDefaultToMatched < ActiveRecord::Migration[7.0]
  def change
    change_column_default :matches, :matched, from: nil, to: false
  end
end

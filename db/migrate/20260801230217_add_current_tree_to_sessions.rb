class AddCurrentTreeToSessions < ActiveRecord::Migration[8.1]
  def change
    add_reference :sessions, :current_tree, null: true, foreign_key: { to_table: :trees }
  end
end

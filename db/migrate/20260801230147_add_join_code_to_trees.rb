class AddJoinCodeToTrees < ActiveRecord::Migration[8.1]
  def up
    add_column :trees, :join_code, :string
    add_index :trees, :join_code, unique: true

    # Anonymous class (not the real Tree model) so this backfill stays correct
    # regardless of how Tree's callbacks/validations evolve later.
    tree = Class.new(ActiveRecord::Base) { self.table_name = "trees" }
    tree.reset_column_information
    tree.find_each do |row|
      row.update_column(:join_code, SecureRandom.alphanumeric(12).scan(/.{4}/).join("-"))
    end

    change_column_null :trees, :join_code, false
  end

  def down
    remove_index :trees, :join_code
    remove_column :trees, :join_code
  end
end

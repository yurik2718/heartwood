class AddPlanToTrees < ActiveRecord::Migration[8.1]
  def change
    add_column :trees, :plan, :string, null: false, default: "free"
    add_column :trees, :plan_expires_at, :datetime
  end
end

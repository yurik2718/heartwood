class Session < ApplicationRecord
  belongs_to :user
  belongs_to :current_tree, class_name: "Tree", optional: true
end

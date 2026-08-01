class TreeMembership < ApplicationRecord
  belongs_to :tree
  belongs_to :user

  # owner: created the tree, sole admin (invite/remove members, delete the tree).
  # editor: full read/write on the tree's data.
  # viewer: read-only. See [[collaboration]].
  ROLES = %w[owner editor viewer].freeze

  validates :role, inclusion: { in: ROLES }
  validates :user_id, uniqueness: { scope: :tree_id }

  def owner?  = role == "owner"
  def editor? = role == "editor"
  def viewer? = role == "viewer"

  def can_edit? = owner? || editor?
end

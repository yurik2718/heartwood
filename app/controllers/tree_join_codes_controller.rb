# Regenerating the tree's invite link revokes the old one — see Tree#reset_join_code!.
class TreeJoinCodesController < ApplicationController
  before_action :require_owner

  def create
    Current.tree.reset_join_code!
    redirect_to tree_memberships_path, notice: t("tree_memberships.flash.code_reset")
  end
end

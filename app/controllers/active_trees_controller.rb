# Switches which of the user's trees is active for this session (nav tree-switcher).
# See [[collaboration]] — a user can belong to several trees (their own plus any
# they've joined) and needs a way to pick which one they're currently browsing.
class ActiveTreesController < ApplicationController
  def update
    membership = Current.user.tree_memberships.find_by(tree_id: params[:tree_id])
    if membership
      Current.session.update!(current_tree: membership.tree)
    else
      flash[:alert] = t("active_tree.flash.not_a_member")
    end
    redirect_back fallback_location: root_path
  end
end

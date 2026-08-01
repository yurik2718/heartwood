# The tree's member list — visible to everyone in the tree; role changes and
# removal are owner-only. See [[collaboration]].
class TreeMembershipsController < ApplicationController
  before_action :require_owner, only: %i[update destroy]
  before_action :set_membership, only: %i[update destroy]

  def index
    @memberships = Current.tree.tree_memberships.includes(:user).order(:role)
  end

  def update
    @membership.update!(role: role_param)
    redirect_to tree_memberships_path
  end

  def destroy
    @membership.destroy!
    redirect_to tree_memberships_path
  end

  private
    # The owner row can't be demoted or removed through this controller.
    def set_membership
      @membership = Current.tree.tree_memberships.find(params[:id])
      head :forbidden if @membership.owner?
    end

    def role_param
      params.require(:tree_membership)[:role].presence_in(%w[editor viewer]) || "editor"
    end
end

# Role checks for collaboration (see [[collaboration]]). Included in
# ApplicationController; each controller opts individual actions in via
# `before_action :require_can_edit` / `:require_owner`.
module TreeAuthorization
  extend ActiveSupport::Concern

  private
    def require_can_edit
      return if Current.membership&.can_edit?
      redirect_to root_path, alert: t("flash.read_only")
    end

    def require_owner
      return if Current.membership&.owner?
      redirect_to root_path, alert: t("flash.owners_only")
    end
end

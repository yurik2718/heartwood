class Current < ActiveSupport::CurrentAttributes
  attribute :session
  attribute :tree
  attribute :membership
  delegate :user, to: :session, allow_nil: true
end

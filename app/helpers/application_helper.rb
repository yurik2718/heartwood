module ApplicationHelper
  def icon_tag(name, **options)
    classes = [ "icon", "icon--#{name}", options.delete(:class) ].compact.join(" ")
    tag.span class: classes, "aria-hidden": true, **options
  end

  # Whether the current membership can add/edit/delete tree data — viewers can't.
  # See [[collaboration]]. Controller-level require_can_edit is the actual
  # security boundary; this just keeps pointless affordances out of the view.
  def can_edit?
    Current.membership&.can_edit?
  end
end

module ApplicationHelper
  def icon_tag(name, **options)
    classes = [ "icon", "icon--#{name}", options.delete(:class) ].compact.join(" ")
    tag.span class: classes, "aria-hidden": true, **options
  end
end

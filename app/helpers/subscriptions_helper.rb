module SubscriptionsHelper
  def maybe_truncated_attribute(attribute)
    if (attribute.size > 30)
      content_tag :span, attribute.truncate(30), data: { toggle: "tooltip", placement: "top", title: attribute }
    else
      attribute
    end
  end
end

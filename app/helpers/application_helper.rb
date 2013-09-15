module ApplicationHelper
  def trend_node(parking)
    trend, previous_available = parking.trend_and_previous_available

    content_tag(:span, nil, class: trend.css_class, alt: previous_available, title: previous_available)
  end

  def embedded?
    controller.action_name == "embed"
  end

  def last_refresh(parkings = @parkings)
    desc = t 'last_refresh_at'
    time = l parkings.first.last_refresh_at.localtime, format: :short
    "#{desc}#{time}"
  end
end

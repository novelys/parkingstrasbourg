module ApplicationHelper
  def trend_node(parking)
    trend_and_previous_available = parking.trend_and_previous_available
    trend = trend_and_previous_available.first
    previous_available = trend_and_previous_available.last
    klass = case trend
    when :down
      "icon-arrow-down-right"
    when :up
      "icon-arrow-up-right"
    when :flat
      "icon-arrow-right"
    when :unknown
      "icon-question-mark"
    end

    content_tag("span", nil, class: "trend #{klass}", alt: previous_available, title: previous_available)
  end
end

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

  def parking_attributes(parking, counter)
    {
      data: {index: counter, lat: parking.lat, lng: parking.lng},
      href: parking_path(parking),
      class: parking_class(parking)
    }
  end

  def location_attributes
    {
      title: t('filters.geoloc.alt-disabled'),
      data: {
        'alt-enabled' => t('filters.geoloc.alt-enabled'),
        'alt-disabled' => t('filters.geoloc.alt-disabled')
      },
      href: '#'
    }
  end

  def free_label(parking = @parking)
    if I18n.locale == :fr
      t('free').pluralize(parking.available)
    else
      t('free')
    end
  end

  def delay_label(delay)
    if delay < 60
      "#{delay} mn"
    else
      "#{delay / 60} h"
    end
  end

  def parking_class(parking)
    klasses = []

    klasses << :closed if parking.is_closed?
    klasses << :full if parking.is_full?
    klasses << :pr if parking.pr?

    klasses
  end
end

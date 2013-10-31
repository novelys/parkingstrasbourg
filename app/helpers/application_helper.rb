module ApplicationHelper
  def trend_node(parking)
    trend, previous_available = parking.trend_and_previous_available

    content_tag(:span, nil, class: trend.css_class, alt: previous_available, title: previous_available)
  end

  def body_class
    klasses = []
    klasses << [controller_name, action_name].join('-')
    klasses << (embedded? && :embed || :nonembedded)
    klasses
  end

  def embedded?
    controller.action_name == "embed"
  end

  def last_refresh(parkings = @parkings)
    desc = t 'last_refresh_at'
    time = l parkings.first.last_refresh_at.localtime, format: :short
    "#{desc}#{time}."
  end

  def parking_attributes(parking, counter)
    attrs = {
      data: {index: counter, lat: parking.lat, lng: parking.lng},
      class: parking_container_class(parking)
    }

    attrs[:href] = parking_path(parking) if action_name != 'embed'
    attrs
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

  def parking_container_class(parking)
    parking_class(parking).unshift(:parking)
  end

  def parking_class(parking)
    klasses = []

    klasses << :closed if parking.is_closed?
    klasses << :full if parking.is_full?
    klasses << :pr if parking.pr?

    klasses
  end

  def container_tag_in_context(parking, parking_counter, &block)
    tag_name = (action_name == "embed" && :div) || :a

    content_tag tag_name, parking_attributes(parking, parking_counter), &block
  end
end

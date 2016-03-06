class ParkingSerializer < ActiveModel::Serializer
  attributes :available, :total, :opened, :trend, :lat, :lng, :address

  def external_id
    subject.id
  end

  def internal_name
    subject.name
  end

  def opened
    !object.is_closed?
  end

  def trend
    object.trend.value
  end
end

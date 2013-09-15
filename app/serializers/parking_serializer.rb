class ParkingSerializer < ActiveModel::Serializer
  attributes :available, :total, :opened, :trend, :lat, :lng, :address
  attribute :external_id, key: :id
  attribute :internal_name, key: :name

  def opened
    !object.is_closed?
  end

  def trend
    object.trend.value
  end
end

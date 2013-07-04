class ParkingSerializer < ActiveModel::Serializer
  attributes :name, :available, :total, :opened, :trend, :lat, :lng
  attribute :external_id, key: :id

  def opened
    !object.is_closed?
  end
end

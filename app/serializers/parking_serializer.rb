class ParkingSerializer < ActiveModel::Serializer
  attributes :name, :available, :total, :opened, :trend
  attribute :external_id, key: :id

  def opened
    !object.is_closed?
  end
end

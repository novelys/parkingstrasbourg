class Availability
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :parking, index: true

  field :is_closed, type: Boolean, default: false
  field :total, type: Integer
  field :available, type: Integer
  field :user_info, type: String

  default_scope order_by(created_at: :asc)
end

class Availability
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :parking, index: true

  field :is_closed, type: Boolean
  field :total, type: Integer
  field :available, type: Integer
  field :user_info, type: String

  default_scope order_by(created_at: :asc)

  index created_at: 1

  alias :last_refresh_at :created_at
end

class Availability
  include Mongoid::Document
  include Mongoid::Timestamps

  ## Relationships
  belongs_to :parking, index: true

  ## Schema
  field :is_closed, type: Boolean
  field :total,     type: Integer
  field :available, type: Integer
  field :user_info, type: String

  ## Indexes
  index created_at: 1

  ## Scopes
  default_scope -> { order_by(created_at: :asc) }

  ## Methods
  alias :last_refresh_at :created_at
end

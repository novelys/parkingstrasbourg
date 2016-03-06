class Availability
  include Mongoid::Document
  include Mongoid::Timestamps

  ## Relationships
  belongs_to :parking

  ## Schema
  field :is_closed, type: Boolean
  field :total,     type: Integer
  field :available, type: Integer

  ## Indexes
  index parking_id: 1, created_at: 1

  ## Scopes
  default_scope -> { order_by(created_at: :asc) }

  scope :around, ->(time) do
    time ||= Time.now
    # Roung minutes by 10s
    minutes = ((time.min / 10) * 10) - 10
    minutes += 60 if minutes < 0
    start = time.change(min: minutes, sec:0)
    finish = start + 20.minutes
    between(created_at: (start..finish))
  end

  ## Methods
  alias :last_refresh_at :created_at

  def is_full?
    available == 0
  end

  def fullish?
    available < (total / (10.0))
  end

  def self.delete_oldest
    delay = 2.years + 2.months
    where(:created_at.lte => delay.ago).delete_all
  end
end

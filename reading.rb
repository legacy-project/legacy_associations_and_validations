class Reading < ActiveRecord::Base

  default_scope { order('order_number') }

  scope :pre, -> { where("before_lesson = ?", true) }
  scope :post, -> { where("before_lesson != ?", true) }

# <<<<<<< HEAD
  validates :order_number, presence: true
  validates :lesson_id, presence: true
  validates :url, presence: true, format: {with: /\w+:\/\/[\w\W]+/}
# =======
  belongs_to :lesson
  has_one :course, through: :lesson
# >>>>>>> cruz

  def clone
    dup
  end
end

class School < ActiveRecord::Base

  default_scope { order('name') }

# <<<<<<< HEAD
  has_many :terms
  has_many :courses, through: :terms
# =======
  validates :name, presence: true
# >>>>>>> cruz
end

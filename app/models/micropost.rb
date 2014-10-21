class Micropost < ActiveRecord::Base
  belongs_to :user
  belongs_to :stock
  has_many :comments
  validates :user_id,presence: true
  validates :content,presence: true,length: {maximum: 500}
end

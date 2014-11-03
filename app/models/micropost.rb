class Micropost < ActiveRecord::Base
  belongs_to :user
  belongs_to :stock

  has_many :goodrelations,foreign_key: "begood_id"
  has_many :goods,through: :goodrelations,source: :good

  has_many :unreadrelations,foreign_key: "unreadmicropost_id"
  has_many :unreadusers,through: :unreadrelations,source: :unreaduser

  has_many :comments
  validates :user_id,presence: true
  validates :content,presence: true,length: {maximum: 500}
end

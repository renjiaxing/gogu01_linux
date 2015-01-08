class Micropost < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  validates :content, presence: true

  belongs_to :user
  belongs_to :stock

  has_many :goodrelations,foreign_key: "begood_id"
  has_many :goods,through: :goodrelations,source: :good

  has_many :anons,foreign_key: "anonmicropost_id"
  has_many :anonusers,through: :anons,source: :anonuser

  has_many :unreadrelations,foreign_key: "unreadmicropost_id"
  has_many :unreadusers,through: :unreadrelations,source: :unreaduser

  has_many :comments

  has_many :replyrelationships,foreign_key: "replymicropost_id"
  has_many :replyusers,through: :replyrelationships,source: :replyuser

  validates :user_id,presence: true
  validates :content,presence: true,length: {maximum: 500}

end

class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer
  belongs_to :question
  belongs_to :poll

  validates :answer_id,presence: true

end

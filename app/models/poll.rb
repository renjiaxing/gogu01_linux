class Poll < ActiveRecord::Base
  has_many :questions,dependent: :destroy
  validates :topic,presence: true

  has_many :votes,dependent: :destroy
  has_many :users,through: :votes

  accepts_nested_attributes_for :questions, :reject_if => :all_blank, :allow_destroy => true

  def polls_summary(poll)
    Vote.where(question_id:poll.questions[0].id).count
  end
end

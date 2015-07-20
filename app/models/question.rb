class Question < ActiveRecord::Base
  belongs_to :poll
  has_many :answers,dependent: :destroy

  has_many :votes,dependent: :destroy
  has_many :users,through: :votes

  validates :title,presence: true

  accepts_nested_attributes_for :answers, :reject_if => :all_blank, :allow_destroy => true

  def normalized_votes_for(option)
    votes_summary == 0 ? 0 : (option.votes.count.to_f / votes_summary) * 100
  end

  def votes_summary
    answers.inject(0) {|summary, option| summary + option.votes.count}
  end

end

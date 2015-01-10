class Story < ActiveRecord::Base
  belongs_to :user
  has_many :votes

  validates :title, :presence => true
  validates :url, :presence => true

  def attributes
    super.merge('score' => self.score)
  end

  def score
    votes.sum(:point)
  end
end

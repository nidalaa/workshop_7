class Vote < ActiveRecord::Base
  belongs_to :story
  belongs_to :user

  validates :point, inclusion: { in: [-1, 1], message: "Vote must be equal to 1 or -1" }
  validates :story, :presence => true
  validates :user, :presence => true

  scope :by_story, ->(story_id) { where(story_id: story_id) }
end

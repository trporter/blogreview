class Post < ActiveRecord::Base

  attr_accessor :tweet_it
  
  has_many :comments, dependent: :destroy
  belongs_to :category
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user

  has_many :votes, dependent: :destroy
  has_many :voting_users, through: :votes, source: :user

  validates :title, presence: true, uniqueness: true
  validates :body, presence: true

  def like_for(user)
    likes.find_by_user_id(user)
  end

  def liked_by?(user)
    likes.exists?(user: user)
  end

  def voted_by?(user)
    votes.exists?(user: user)
  end

  def vote_for(user)
    votes.find_by_user_id user
  end

  def voted_up_by?(user)
    voted_by?(user) && vote_for(user).is_up?
  end

  def voted_down_by?(user)
    voted_by?(user) && !vote_for(user).is_up? # ! means not
  end

  def up_votes
    votes.where(is_up: true).count
  end

  def down_votes
    votes.where(is_up: false).count
  end

  def vote_sum
    up_votes - down_votes
  end

  def comments_new_first
    comments.order(created_at: :desc)
  end

end

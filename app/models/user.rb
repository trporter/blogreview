class User < ActiveRecord::Base
  has_secure_password

  has_many :posts, dependent: :nullify
  has_many :likes, dependent: :nullify
  has_many :liked_posts, through: :likes, source: :post
  has_many :votes, dependent: :nullify

  validates :first_name, presence: true, unless: :using_oauth?
  validates :last_name, presence: true, unless: :using_oauth?
  validates :email, presence: true, uniqueness: true, format:  /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, unless: :using_oauth?
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true, unless: :using_oauth?

  def full_name
    "#{first_name} #{last_name}"
  end

  def using_oauth?
    uid.present? && provider.present?
  end

  def self.find_or_create_from_twitter(twitter_data)
    user = User.where(uid: twitter_data["uid"], provider: twitter_data["provider"]).first
    user = create_from_twitter(twitter_data) unless user
    user
  end

  def self.create_from_twitter(twitter_data)
    user = User.new
    full_name = twitter_data["info"]["name"].split(" ")
    user.first_name = full_name.first
    user.last_name = full_name.last
    user.uid = twitter_data["uid"]
    user.provider = twitter_data["provider"]
    user.twitter_token = twitter_data["credentials"]["token"]
    user.twitter_secret = twitter_data["credentials"]["secret"]
    user.twitter_raw_data = twitter_data
    user.password = SecureRandom.urlsafe_base64
    user.save!
    user
  end

  def using_twitter?
    using_oauth? && provider =="twitter"
  end

end

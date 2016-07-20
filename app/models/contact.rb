class Contact < ActiveRecord::Base
  validates :email, format: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :name, presence: true
  validates :subject, presence: true
  validates :message, presence: true
end

class User < ApplicationRecord
    validates :username, presence: true, length: { maximum: 25 }
    validates :email, presence: true
    validates :password, presence: true, length: { in: 5..16 }

    has_many :posts
    has_many :comments
end


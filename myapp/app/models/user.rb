class User < ActiveRecord::Base
  #day la tao them 2 bien-> cai se dung sau nay!!!
  attr_accessor :remember_token, :activation_token

  before_save :downcase_email
  before_create :create_activation_digest
  has_many :microposts
  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 },  allow_nil: true

#encrypt passowrd
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  # get token-> encrypte token -> update to remember digest
  # co ban la hieu -> truyen vao thang remeber token -> save vao thang remember digest
  def remember
    self.remember_token = User.new_token
    # digest remember_token which is created from base64 library
    # -> update vao cai thang remember_digest!!!
    # noi chung la cu phai tu tu moi hieu het duoc !!!
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  # pass rember_token

  def authenticated?(attribute, token)
    # attribute = remember || activation
    # becuase both are get token -> check the token
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    # return false if remember_digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  private
    def downcase_email
      self.email = email.downcase
    end
    # create activation token

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end

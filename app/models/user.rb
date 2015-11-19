class User < ActiveRecord::Base
  attr_reader :password
  validates :user_name, :password_digest, :session_token, presence: true
  after_initialize :ensure_session_token
  validates :password, length: { minimum: 6, allow_nil: true}

  has_many :cats,
    class_name: "Cat",
    foreign_key: :user_id,
    primary_key: :id

  has_many :rental_requests,
    class_name: "CatRentalRequest",
    foreign_key: :user_id,
    primary_key: :id

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    # user = User.find_by_user_name(user_name)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

end

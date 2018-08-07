class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  has_many :orders, dependent: :destroy
  has_one :giftcode, dependent: :destroy
  validates :name, presence: true, length: {maximum: Settings.leng_name_max}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Settings.leng_email_max}, format: {with: VALID_EMAIL_REGEX},
   uniqueness: true
  validates :password, presence: true, length: {minimum: Settings.leng_pass_min}, allow_nil: true
  validates :phone, presence: true, numericality: true, length: {maximum: Settings.leng_phone_max}
  validates :address, presence: true, length: {maximum: Settings.leng_address_max}
  validates :gender, presence: true
  validate  :picture_size
  before_save :downcase_email
  before_create :create_activation_digest
  enum role: {admin: 0, user: 1, customer: 2}
  scope :search_by_name, ->(key){where("email LIKE ? OR name LIKE ?", "%#{key}%", "%#{key}%") if key.present?}
  has_secure_password
  mount_uploader :avartar, PictureUploader

  def self.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update(remember_digest: User.digest(remember_token))
  end

  def forget
    update(remember_digest: nil)
  end

  def picture_size
    return if avartar.size <= Settings.pic_size.megabytes
    errors.add(:avartar, t("model.user.pic_less_5"))
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update(activated: true)
    update(activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update(reset_digest: User.digest(reset_token))
    update(reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.res_expired.hours.ago
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end

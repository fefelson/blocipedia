class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :wikis # (?) dependent: :destroy

  before_save -> { self.email = email.downcase }, if: -> { email.present? }

  validates_presence_of :name
  validates_uniqueness_of :name, { case_sensitive: false}
  validates_length_of :name, {minimum: 4, maximum: 10}

  validates_length_of :email, minimum: 3

  after_create :send_new_user_email , if: -> {email.present? & name.present?}

  private

  def send_new_user_email
      UserMailer.new_user(self).deliver_now
  end
end

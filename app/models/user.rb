class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :trackable, :validatable

  has_many :wikis # (?) dependent: :destroy

  before_save -> { self.email = email.downcase }, if: -> { email.present? }

  after_initialize -> { self.role ||= :standard }

  after_create :send_new_user_email, if: -> { valid? }

  validates :name, uniqueness: { case_sensitive: false },
                   presence: true,
                   length: {minimum: 4, maximum: 10}

  validates :email, uniqueness: { case_sensitive: false },
                    presence: true,
                    length: { minimum: 3 }

  enum role: [:admin, :standard, :premium]

  private

  def send_new_user_email
      UserMailer.new_user(self).deliver_now
  end
end

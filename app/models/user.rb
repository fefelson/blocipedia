class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:standard, :premium, :admin]

  has_many :wikis # (?) dependent: :destroy

  before_save -> { self.email = email.downcase }, if: -> { email.present? }

  after_create :send_new_user_email, if: -> { valid? }

  validates :name, uniqueness: { case_sensitive: false },
            presence: true,
            length: {minimum: 4, maximum: 10}

  validates :email, uniqueness: { case_sensitive: false },
            presence: true,
            length: { minimum: 3 }
                    
  validates :role, presence: true,
            inclusion: { in: roles.keys , message: "%{value} is not a valid role" }

  private

  def send_new_user_email
      UserMailer.new_user(self).deliver_now
  end
end

class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :trackable, :validatable

  enum role: [:standard, :premium, :admin]

  has_many :wikis # (?) dependent: :destroy
  has_many :collaborations
  has_many :shared_wikis, through: :collaborations, source: :wiki

  before_save -> { self.email = email.downcase }, if: -> { email.present? }

  # after_create :send_new_user_email, if: -> { valid? }

  validates :name, uniqueness: { case_sensitive: false },
            presence: true,
            length: {minimum: 4, maximum: 26}

  validates :email, uniqueness: { case_sensitive: false },
            presence: true,
            length: { minimum: 3 }

  validates :role, presence: true,
            inclusion: { in: roles.keys , message: "%{value} is not a valid role" }

  def downgrade!
    ActiveRecord::Base.transaction do
      standard!
      wikis.each(& :public!)
    end
  end

  private

  def send_new_user_email
      UserMailer.new_user(self).deliver_now
  end
end

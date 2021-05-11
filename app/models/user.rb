class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :surveys,dependent: :destroy,class_name: "LeadershipSurvey"  
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         omniauth_providers: %i[google_oauth2 facebook]

  has_many :test_invites,class_name: "TestInvite",foreign_key: "invitee_id",dependent: :destroy     
  has_many :invites, -> { distinct },class_name: "LeadershipSurvey",through: :test_invites,source: :test    
  validates_uniqueness_of :email
  attr_accessor :test_id
  monetize :balance_cents,as: "balance"  

  has_attached_file :profile_pic, styles: { medium: "300x300", small: "150x150" },default_url: "/avatar.png"
  validates_attachment_content_type :profile_pic, content_type: /\Aimage\/.*\z/

  has_one :logbook, dependent: :destroy
  # accepts_nested_attributes_for :logbook

  def make_admin
    update!(admin: true)
  end

  # Excel Upload Feature
  has_one :document, dependent: :destroy, as: :owner
  accepts_nested_attributes_for :document, reject_if: :all_blank,
                                           allow_destroy: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = SecureRandom.hex(8)
    end
  end
end

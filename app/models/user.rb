class User < ActiveRecord::Base
  attr_accessible :email, :name

  before_save { |user| user.email = email.upcase }

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #uniqueness : { case_sensitive: false } ����email��Ψһ�ԣ��������ִ�Сд
  validates :email, presence: true,
  	format: { with: VALID_EMAIL_REGEX },
	uniqueness: { case_sensitive: false }
end

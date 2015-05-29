class User < ActiveRecord::Base
  #attr_accessible :name, :email, :password, :password_confimation, :store
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise  :database_authenticatable, :confirmable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :password_expirable # , :registerable, :invitable

  before_create :assign_role

  def assign_role
    self.add_role :user if self.roles.first.nil?
  end

end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  
  has_many :user_projects
  has_many :projects, through: :user_projects
  #has_many :projects
  
  enum user_type: {
    Manager: 0,
    Developer:1,
    QA: 2
  }
end

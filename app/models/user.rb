class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_save {self.email = email.downcase}
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :email, presence: true
  
  
  has_many :user_projects
  #has_many :projects, through: :user_projects
  has_many :assigned_projects, through: :user_projects, source: :project
  has_many :created_projects, class_name: "Project", foreign_key: :creator_id

  has_many :created_bugs, class_name: "Bug", foreign_key: "creator_id"
  has_many :solved_bugs, class_name: "Bug", foreign_key: "solver_id"

  has_many :bugs, through: :created_projects

  
  enum user_type: {
    Manager: 0,
    Developer: 1,
    QA: 2
  }
end

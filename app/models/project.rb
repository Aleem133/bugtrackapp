class Project < ApplicationRecord

    validates :title, presence: true
    validates :description, presence: true
    
    
    has_many :user_projects
    has_many :users, through: :user_projects
    #belongs_to :manager, class_name: "user", foreign_key: "creator_id"
    

end
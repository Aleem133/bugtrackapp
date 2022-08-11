class Bug < ApplicationRecord
    validates :title, presence: true, uniqueness: { case_sensitive: false }
    
    
    belongs_to :project
    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
    belongs_to :solver, class_name: "User", foreign_key: "solver_id"
    
    enum bug_type: {
        feature: 0,
        bug: 1
    }

end
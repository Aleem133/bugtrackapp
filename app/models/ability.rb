class Ability
    include CanCan::Ability
  
    def initialize(current_user)
        current_user ||= User.new
        if current_user.Manager?
            can :create, Project
            can :read, Project , creator_id: current_user.id
            can :edit, Project , creator_id: current_user.id
            can :destroy, Project , user: current_user
            can :read, Bug
        elsif current_user.Developer?
            can :read, Project
            can [:update, :read], Bug
        elsif current_user.QA?
            can :read, Project
            can [:create, :read, :update, :destroy], Bug
        end
        
    end
end
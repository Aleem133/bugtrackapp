class Ability
    include CanCan::Ability
  
    def initialize(user)
        if current_user.Manager
            can [:create, :read, :update, :delete], Project, user: user
            can :read, Bug, user: user
        elsif current_user.Developer
            can :read, Project, user: user
            can [:update, :read], Bug, user: user
        else
            can :read, Project, user: user
            can [:create, :read, :update, :delete], Bug, user: user
        end
    end
end
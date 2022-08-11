class Ability
    include CanCan::Ability
  
    def initialize(user)
        
        if user.Manager?
            
            can [:create, :read, :update, :delete], Project, user: user
            can :read, Bug, user: user
        elsif user.Developer?
            can :read, Project, user: user
            can [:update, :read], Bug, user: user
        else
            can :read, Project, user: user
            can [:create, :read, :update, :delete], Bug, user: user
        end
        
    end
end
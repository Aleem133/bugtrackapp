class BugsController < ApplicationController

    before_action :authenticate_user!
    before_action :set_bug, only: [:show, :edit, :update, :destroy]
    before_action :require_same_user, only: [:show,:edit]

    load_and_authorize_resource
    skip_authorize_resource only: [:edit, :new]

    def index
        #@bugs = Bug.paginate(page: params[:page],per_page: 5)
        if current_user.usertype == 'QA'
            @bugs = current_user.created_bugs.paginate(page: params[:page],per_page: 5)
        elsif current_user.usertype == 'Developer'
            @bugs = current_user.solved_bugs.paginate(page: params[:page],per_page: 5)
        elsif current_user.usertype == 'Manager'
            @bugs = current_user.bugs.paginate(page: params[:page], per_page: 5)
        end
    end

    def new
        @bug = Bug.new
    #     @project = Project.find(params['project_id'])
    # rescue ActiveRecord::RecordNotFound
    #     if @project.nil?
    #         flash[:notice] = "Can not create bug"
    #         redirect_to root_path
    #     end
        #binding.pry

        @project = Project.find_by(:id => params['project_id'])
        if @project.nil?
            flash[:notice] = "Can not create bug"
            redirect_to root_path
        else
            @devs = @project.users.Developer
            if can? :new, @bug
                
            else
                flash[:notice] = "You can not create bug"
                redirect_to root_path
            end
        end
    end

    def create
        #binding.pry
        #@devs = Project.find(params['project_id']).users.Developer
        

        if current_user.usertype == 'QA'
            @bug = Bug.new(bug_params)
            @bug.creator_id = current_user.id
            #@bug.solver_id = 2
            #@bug.project_id = project_id
            
            #code to check for unique title name of bug
            @bugs = Project.find(@bug.project_id).bugs
            @present = false
            @bugs.each do |bug|
                if bug.title == @bug.title
                    @present = true
                    break
                end
            end

            if !@present
                if @bug.save
                    flash[:success] = "Bug created successfully"
                    redirect_to bug_path(@bug)
                elsif
                    flash[:notice]= "Either your feilds are empty or Screenshot should be in .png or .gif"
                    redirect_to new_bug_path(:project_id => @bug.project_id)
                end
            else @present
                flash[:notice]= "Bug with same title already exist in this project"
                redirect_to new_bug_path(:project_id => @bug.project_id)
            end
        else
            redirect_to root_path
        end
    end

    def edit
        @project = Project.find_by(:id => @bug.project_id)
        #binding.pry
        # if @project.nil?
        #     flash[:notice] = "Can not edit bug"
        #     redirect_to root_path
        # else
            @devs = @project.users.Developer

            if can? :edit, @bug

            else
                flash[:notice] = "You can not edit this bug"
                redirect_to root_path
            end
        #end
    end

    def show
        if current_user.usertype == 'QA' && current_user.id == @bug.creator_id
            @user_bugs = current_user.created_bugs.paginate(page: params[:page], per_page: 5)
        elsif current_user.usertype == 'Developer' && current_user.id == @bug.solver_id
            @user_bugs = current_user.solved_bugs.paginate(page: params[:page], per_page: 5)
        elsif current_user.usertype == 'Manager' && current_user.id == @bug.project.creator_id
            @user_bugs = current_user.bugs.paginate(page: params[:page], per_page: 5)
        end
    end


    def update
        #@devs = Project.find(params['project_id']).users.Developer
        if current_user.usertype == 'QA' || current_user.usertype == 'Developer'
            @bugs = Project.find(@bug.project_id).bugs
            @present = false
            @bugs.each do |bug|
                if bug.title == @bug.title
                    @present = true
                    break
                end
            end
            binding.pry
            if !@present
                if @bug.update(bug_params)
                    flash[:success]= "Project updated Succesfully"
                    redirect_to bug_path(@bug)
                else
                    flash[:notice]= "Either fields are empty or Screenshot should be in .png or .gif"
                    redirect_to edit_bug_path(@bug, :project_id => @bug.project_id)
                end
            elsif @present
                flash[:notice]= "Bug with same title already exist in this project"
                redirect_to edit_bug_path(@bug, :project_id => @bug.project_id)
            end
        else
            redirect_to root_path
        end
    end

    def destroy
        @bug = Bug.find(params[:id]).destroy
        flash[:success]= "Bug deleted Succesfully"
        redirect_to bugs_path
    end

    private

    def set_bug
        @bug = Bug.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        flash[:notice] = "Bug does not exist"
        redirect_to root_path
    end

    def require_same_user
        if current_user.usertype == 'QA' && current_user.id != @bug.creator_id
            flash[:notice] = "You have no access to this resource"
            redirect_to root_path
        elsif current_user.usertype == 'Developer' && current_user.id != @bug.solver_id
            flash[:notice] = "You have no access to this resource"
            redirect_to root_path
        elsif current_user.usertype == 'Manager' && current_user.id != @bug.project.creator_id
            flash[:notice] = "You have no access to this resource"
            redirect_to root_path
        end
    end
    

    def bug_params
        params.require(:bug).permit(:title, :description, :deadline, :bug_type, :status, :solver_id, :project_id, :image)
    end
    
end
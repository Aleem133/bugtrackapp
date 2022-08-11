class BugsController < ApplicationController

    before_action :set_bug, only: [:show,:edit,:update,:destroy]
    before_action :require_user
    def index
        #@bugs = Bug.paginate(page: params[:page],per_page: 5)
        if current_user.usertype == 'QA'
            @bugs = current_user.created_bugs.paginate(page: params[:page],per_page: 5)
        elsif current_user.usertype == 'Developer'
            @bugs = current_user.solved_bugs.paginate(page: params[:page],per_page: 5)
        else
            #@projects = current_user.created_projects
            #binding.pry
            @bugs = current_user.bugs.paginate(page: params[:page], per_page: 5)
            #Projects.joins(:bug)#.where(['bug.project_id = ?','current_user.created_projects']).paginate(page: params[:page],per_page: 5)
            #pages = Page.joins(:subject).where(['subjects.name = ? AND subjects.level = ? AND pages.name LIKE ?', 'Math', 2, '%Division'])                
        end
    end

    def new
        @bug = Bug.new
        @devs = Project.find(params['project_id']).users.Developer
    end

    def create
        #binding.pry
        #@devs = Project.find(params['project_id']).users.Developer
        if current_user.usertype == 'QA'
            @bug = Bug.new(bug_params)
            @bug.creator_id = current_user.id
            #@bug.solver_id = 2
            #@bug.project_id = project_id
            if @bug.save
                flash[:success] = "Bug created successfully"
                redirect_to bug_path(@bug)
            else
                render 'new'
            end
        else
            redirect_to root_path
        end
    end

    def edit
        @devs = Project.find(params['project_id']).users.Developer
    end

    def show
        if current_user.usertype == 'QA'
            @user_bugs = current_user.created_bugs.paginate(page: params[:page], per_page: 5)
        elsif current_user.usertype == 'Developer'
            @user_bugs = current_user.solved_bugs.paginate(page: params[:page], per_page: 5)
        else
            @user_bugs = current_user.bugs.paginate(page: params[:page], per_page: 5)
        end
    end


    def update
        if current_user.usertype == 'QA' || current_user.usertype == 'Developer'
            if @bug.update(bug_params)
                flash[:success]= "Project updated Succesfully"
                redirect_to bug_path(@bug)
            else
                render 'edit'
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
    end

    def bug_params
        params.require(:bug).permit(:title, :description, :deadline, :bug_type, :status, :solver_id, :project_id, :image)
    end
    
end
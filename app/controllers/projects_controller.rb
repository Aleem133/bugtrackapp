class ProjectsController < ApplicationController
    
    before_action :authenticate_user!
    

    before_action :set_project, only: [:show,:edit,:update,:destroy]
    before_action :require_user
    

    def index
        #binding.pry
        if current_user.usertype == 'Manager'
            @projects = current_user.created_projects.paginate(page: params[:page],per_page: 5)
        else
            @projects = current_user.projects.paginate(page: params[:page],per_page: 5)
        end
    end

    def new
        if current_user.usertype == 'Manager'
            @project = Project.new
        end
    end

    def create
        if current_user.usertype == 'Manager'
            @project = Project.new(project_params)
            @project.creator_id = 1
            if @project.save
                flash[:success] = "Project created successfully"
                redirect_to project_path(@project)
            else
                render 'new'
            end
        end
    end

    def show
        
    end

    def edit

    end

    def update
        if current_user.usertype == 'Manager'
            if @project.update(project_params)
                flash[:success]= "Project updated Succesfully"
                redirect_to project_path(@project)
            else
                render 'edit'
            end
        end
    end

    def destroy
        if current_user.usertype == 'Manager'
            @project = Project.find(params[:id]).destroy
            flash[:success]= "Project deleted Succesfully"
            redirect_to projects_path
        end
    end

    private
    
    def set_project
        @project = Project.find(params[:id])
    end

    def project_params
        params.require(:project).permit(:title, :description, user_ids: [])
    end
end
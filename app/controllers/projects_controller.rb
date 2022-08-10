class ProjectsController < ApplicationController
    
    before_action :set_project, only: [:show,:edit,:update,:destroy]
    before_action :require_user

    def index
        @projects = Project.paginate(page: params[:page],per_page: 5)
    end

    def new
        @project = Project.new
    end

    def create
        @project = Project.new(project_params)
        @project.creator_id = 1
        if @project.save
            flash[:success] = "Project created successfully"
            redirect_to project_path(@project)
        else
            render 'new'
        end
    end

    def edit

    end

    def update
        if @project.update(project_params)
            flash[:success]= "Project updated Succesfully"
            redirect_to project_path(@project)
        else
            render 'edit'
        end

    end

    def destroy
        @project = Project.find(params[:id]).destroy
        flash[:success]= "Project deleted Succesfully"
        redirect_to projects_path
    end

    private
    
    def set_project
        @project = Project.find(params[:id])
    end

    def project_params
        params.require(:project).permit(:title, :description)
    end
end
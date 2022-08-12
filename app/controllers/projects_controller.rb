class ProjectsController < ApplicationController
    
    before_action :authenticate_user!
    before_action :set_project, only: [:show,:edit,:update,:destroy]
    before_action :require_same_user, only: [:show,:edit]
    load_and_authorize_resource
    skip_authorize_resource only: [:edit, :new]
    

    def index
        #binding.pry
        if current_user.usertype == 'Manager'
            @projects = current_user.created_projects.paginate(page: params[:page],per_page: 5)
        else
            @projects = current_user.projects.paginate(page: params[:page],per_page: 5)
        end
    end

    def new
        @project = Project.new
        #commenting this one after adding load and authorize
        if can? :create, @project

        else 
            flash[:notice] = "You can not create project"
            redirect_to root_path
        end



        # if current_user.usertype == 'Manager'
        #     @project = Project.new
        # end
    end

    def create
        @project = Project.new(project_params)
        @project.creator_id = current_user.id
        if @project.save
            flash[:success] = "Project created successfully"
            redirect_to project_path(@project)
        else
            render 'new'
        end        
    end

    def show
        # if can? :show, Project

        # end

        # if current_user.usertype != 'Manager' || current_user.id != @project.creator_id
        #     flash[:notice] = "You can not access this project"
        #     redirect_to root_path
        # end
    end

    def edit
        
        if can? :edit, @project

        else
            flash[:notice] = "You can not edit this project"
            redirect_to root_path
        end
        # if current_user.usertype != 'Manager' || current_user.id != @project.creator_id
        #     flash[:notice] = "You can not access this project"
        #     redirect_to root_path
        # end
    end

    def update
        if current_user.usertype == 'Manager' && current_user.id == @project.creator_id
            if @project.update(project_params)
                flash[:success]= "Project updated Succesfully"
                redirect_to project_path(@project)
            else
                render 'edit'
            end
        end
    end

    def destroy
        #if current_user.usertype == 'Manager' && current_user.id == @project.creator_id
            @project = Project.find(params[:id]).destroy
            flash[:success]= "Project deleted Succesfully"
            redirect_to projects_path
        #end
    end

    private
    
    def set_project
        #binding.pry
        @project = Project.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        flash[:notice] = "Project does not exist"
        redirect_to root_path
    end

    def require_same_user

        @ids = @project.users.ids
        @present = false
        @ids.each do |id|
            if id == current_user.id
                @present = true
                break
            end
        end
        #binding.pry
        if current_user.usertype == 'Manager' && current_user.id != @project.creator_id
            flash[:notice] = "You have no access to this resource"
            redirect_to root_path
        elsif (current_user.usertype == 'Developer' || current_user.usertype == 'QA') && !@present
            flash[:notice] = "You have no access to this resource"
            redirect_to root_path
        # elsif current_user.usertype == 'QA' && current_user.id != @project.project.creator_id
        #     flash[:notice] = "You have no access to this resource"
        #     redirect_to root_path
        end
    end

    def project_params
        params.require(:project).permit(:title, :description, user_ids: [])
    end
end
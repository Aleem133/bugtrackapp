class BugsController < ApplicationController

    before_action :set_bug, only: [:show,:edit,:update,:destroy]
    before_action :require_user
    def index
        @bugs = Bug.all
    end

    def new
        @bug = Bug.new
    end

    def create
        @bug = Bug.new(bug_params)
        @bug.creator_id = 3
        @bug.solver_id = 2
        @bug.project_id = 1
        if @bug.save
            flash[:success] = "Bug created successfully"
            redirect_to bug_path(@bug)
        else
            render 'new'
        end

    end

    def edit

    end

    def update
        if @bug.update(bug_params)
            flash[:success]= "Project updated Succesfully"
            redirect_to bug_path(@bug)
        else
            render 'edit'
        end
    end

    def destroy
        @bug = Bug.find(params[:id]).destroy
        flash[:success]= "Bug deleted Succesfully"
        redirect_to bugs_path
    end

    def set_bug
        @bug = Bug.find(params[:id])
    end

    def bug_params
        params.require(:bug).permit(:title, :description,:deadline,:bug_type,:status)
    end
    
end
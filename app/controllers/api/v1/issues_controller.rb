module Api
  module V1
    class IssuesController < ApplicationController
      skip_before_filter :verify_authenticity_token
      before_action :find_user, only: [:create, :get_issues_for_user, :update_issue_to_user]

      def create
        if params[:issue].present?
          @issue = @user.issues.build(issue_params)
          if @issue.save
            render :json => {:success=>true,message:"Successfully created issue",data: @issue},:status => 200
          else
            render :json => {:success=>false,message:"Invalid entry",errors: @issue.errors},:status => 401
          end
        else
          render json: { :success=>false, message: "Fill the empty fields" }, :status => 402
        end
      end

      def index
        @issue = Issue.all
        if @issue.present?
          render :json => {:success=>true,message:"Successfully listed issues",data: @issue},:status => 200
        else
          render :json => {:success=>false,message:"No issues found", data: @issue},:status => 200
        end
      end

      def update_issue_to_user
        @user.issues = Issue.where('id IN(?)', params[:issues][:issues_ids])
        if @user.save
          render :json => {:success=>true,message:"Successfully update issue",data: @user.issues},:status => 200
        else
          render :json => {:success=>false, message:"Fail to update",errors: @user.errors},:status => 401
        end
      end

      def get_issues_for_user
        @issues = @user.issues
        if @issues.present?
          render :json => {:success=>true,data: @issues,message: "Successfully listed user issues"},status:200
        else
          render :json => {:success=>true, data: @issues, message: "No issues found"}, :status => 200
        end
      end

      private

      def find_user
        begin
          @user = User.find(params[:id])
        rescue
          render :json => {:success=>false,message: "Invalid user"}, :status => 422
        end
      end

      def issue_params
        params.require(:issue).permit(
          :name
          )
      end
    end
  end
end

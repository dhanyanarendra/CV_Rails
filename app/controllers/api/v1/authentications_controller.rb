module Api
  module V1
    class AuthenticationsController < ApplicationController
      skip_before_filter :verify_authenticity_token

      def authenticate
        @user = User.find_by_email(params[:user][:email].downcase)
        if @user
          if @user.has_role? :user
            get_campaign_and_authenticate_user
          else
            render :json => {:success=>false, message:"Email id registered as a Coordinator/Admin"}, :status => 401
          end
        else
          render_invalid_json
        end
      end

      def authenticate_for_web
        @user = User.find_by_email(params[:user][:email].downcase)
        if @user
          if (@user.has_role? :admin) || (@user.has_role? :cordinator)
            get_campaign_and_authenticate_user
          else
            render :json => {:success=>false, message:"You are not an invited coordinator"}, :status => 401
          end
        else
          render_invalid_json
        end
      end

      private

      def get_campaign_and_authenticate_user
        @campaign = Campaign.where('id=?', @user.campaign_id).first
        @campaign = @campaign.present? ? @campaign : {}
        if @user.authenticate(params[:user][:password])
          render :json => {:success=>true,message:"Successfully loggedin",:data => @user.as_json, :campain => @campaign.as_json, :roles => @user.roles.as_json}, :status => 200
        else
          render_invalid_json
        end
      end

      def render_invalid_json
        render :json => {:success=>false, message:"Invalid Email or Password"},:status => 422
      end
    end
  end
end

module Api
  module V1
    class InvitesController < ApplicationController
      skip_before_filter :verify_authenticity_token

      def create
        if params[:invite].present?
          @invite = Invite.new(invite_params)
          @user = User.find_by_id params[:id]
          @invite.user_id = @user.id
          @invite.campaign_id = @user.campaign.id
          if @invite.save
            InviteMailer.invite_user(@invite).deliver

            render :json => {:success=>true,message:"Successfully created invite",data: @invite},:status => 200
          else
            render :json => {:success=>false,message:"Fail to create invite",errors: @invite.errors},:status => 422
          end
        else
          render json: { :success=>false, message: "Fill the empty fields" }, :status => 422
        end
      end

      def get_invites
        @invites = Invite.all
        if @invites.present?
          render :json => {:success=>true,message:"Successfully listed Invites",data: @invites},:status => 200
        else
          render :json => {:success=>false,message:"No invites found", data: @invites},:status => 200
        end
      end


      private

      def render_invalid_json
        render :json => {:success=>false, message:"Invalid Email or Password"},:status => 422
      end

      def invite_params
        params.require(:invite).permit(
          :first_name,
          :last_name,
          :email,
          :short_description,
          :user_role
          )
      end
    end
  end
end

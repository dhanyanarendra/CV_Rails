module Api
  module V1
    class CampaignsController < ApplicationController
      skip_before_filter :verify_authenticity_token
      before_action :find_user, only: [:create, :show, :get_campaign_for_user]

      def create
        if @user.has_role? :admin
          unless @user.campaign.present?
            if params[:campaign].present?
              @campaign = @user.build_campaign(campaign_params)
              @campaign.creator_id = @user.id
              if @campaign.save
                @user.update_attributes(:campaign_id => @campaign.id)
                session[:campaign_id] = @campaign.id
                render :json => {:success=>true,message:"Successfully created campaign",data: @campaign,:status => 200}
              else
                render :json => {:success=>false,message:"Invalid entry",errors: @campaign.errors,:status => 401}
              end
            else
              render json: {:success=>false, message: "Fill the empty fields" , :status => 402}
            end
          else
            render json: {:success=>false, message: "You have Campaign already", :status => 402 }
          end
        else
          render json: {:success=>false, message: "User don't have permission to create", :status => 401 }
        end
      end


      def index
        @campaign = Campaign.all
        if @campaign.present?
          render :json => {:success=>true,message:"Successfully listed campaigns",data: @campaign},:status => 200
        else
          render :json => {:success=>false,message:"No campaigns found", data: @campaign},:status => 200
        end
      end

      def show
        @campaign = Campaign.where('id=?', params[:campaign_id]).first
        if @campaign
          render :json => {:success=>true,message:"Successfully listed campaign",data: @campaign},:status => 200
        else
          render :json => {:success=>false,message:"Campaign not found"},:status => 422
        end
      end

      def get_campaign_for_user
        @campaign = @user.campaign
        if @campaign.present?
          render :json => {:success=>true,message:"Successfully listed campaign for user",data: @campaign},:status => 200
        else
          render :json => {:success=>false,message:"Campaign not found for current user"},:status => 200
        end
      end

      def destroy
        begin
          @campaign = Campaign.find params[:campaign_id]
          if @campaign && @campaign.destroy
            delete_user_for_campaign
            render json: { :success=>true,data: @campaign, message: "campaign has been deleted successfully with campaign" }, :status => 200
          else
            render json: {:success=>false, message: "campaign Not deleted"}, :status => 422
          end
        rescue
          render :json => {:success=>false,message:"campaign not found"},:status => 402
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

      def campaign_params
        params.require(:campaign).permit(
          :candidate_name,
          :district,
          :year,
          :state,
          :election,
          :link
          )
      end

      def delete_user_for_campaign
        @roles = Role.find_by_name('cordinator')
        @cordinators = @roles.present? ? @roles.users.where('campaign_id=?', @campaign.id) : []
        if @cordinators.present?
          @cordinators.each do |cordinator|
            cordinator.destroy
            cordinator.invite.destroy if cordinator.invite.present?
          end
        end
      end
    end
  end
end

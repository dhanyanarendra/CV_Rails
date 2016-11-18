module Api
  module V1
    class UsersController < ApplicationController
      skip_before_filter :verify_authenticity_token

      def create
        if params[:user].present?
          @user = User.create(user_params)
          if params[:user][:invite_id].present?
            @invite = Invite.find_by_id params[:user][:invite_id]
            @user.first_name = @invite.first_name
            @user.last_name = @invite.last_name
            @user.invite_id = @invite.id
            @user.campaign_id = @invite.campaign_id
            @user.add_role :cordinator
            @user.role_name = "cordinator"
          else
            @user.add_role :user
            @user.role_name = "user"
          end
          if @user.valid? && @user.save
            @campaign = Campaign.where('id=?', @user.campaign_id).first
            @campaign = @campaign.present? ? @campaign : {}
            render :json => {:success=>true,message:"Successfully created user",data: @user.as_json(:include=> :invite),:campain => @campaign.as_json},:status => 200
          else
            render :json => {:success=>false,:data => @user.errors.full_messages.join(', '), :message => "Fail to create User"}, :status => 404
          end
        else
          render :json => {:success=>false,message:"Invalid entry"},:status => 404
        end
      end


      def get_cordinators_for_campaign
        @campaign = Campaign.find_by_id params[:id]
        if @campaign.present?
          @roles = Role.find_by_name('cordinator')
          @cordinators = @roles.present? ? @roles.users.where('campaign_id=?', @campaign.id) : []
          if @cordinators.present?
            render :json => {:success=>true,message:"Successfully listed cordinators",data: @cordinators},:status => 200
          else
            render :json => {:success=>false,message:"No cordinators found", data: @cordinators}, :status => 200
          end
        else
          render :json => {:success=>false,message:"No campaign found"}, :status => 200
        end
      end

      def destroy
        @user = User.find_by_id params[:id]
        if @user && @user.destroy
          @user.invite.destroy if @user.invite.present?
          render :json => {:success=>true,message:"Successfully deleted user",data: @user},:status => 200
        else
          render :json => {:success=>false,message:"No user found"}, :status => 404
        end
      end


      def index
        @users = User.all
        if @users.present?
          render json: {:success=>true,data: @user,message: "Successfully listed users"},:status => 200
        else
          render :json => {:success=>false,message:"No users found", data: @users}, :status => 200
        end
      end

      def show
        @user = User.find_by_id(params[:id])
        if @user
          render :json => {:success=>true,data: @user, roles: @user.roles.as_json,message: "Successfully listed user"},status:200
        else
          render :json => {:success=>false,message: "Invalid user"}, :status => 422
        end
      end

      def update
        @user = User.find_by_id(params[:id])
        if @user && !user_params.blank?
          if @user.update_attributes(user_params)
            render json: { :success=>true, data: @user, message: "Successfully updated user" }, :status => 200
          else
            render json: { :success=>false, error: @user.errors , message: "Please fill the empty fields" }, :status => 422
          end
        else
          render json: {:success=>false, message: "User not found"}, :status => 422
        end
      end

      def update_user_with_campaign
        @user = User.find_by_id(params[:id])
        @campaign = Campaign.find_by_id(params[:campaign_id])
        if @campaign.present?
          @user.campaign_id = @campaign.id
          if @user.save
            render json: { :success=>true,data: @user, message: "User has been updated successfully with campaign", :campain => @campaign.as_json }, :status => 200
          else
            render json: {:success=>false, message: "User Not updated"}, :status => 422
          end
        else
          render json: {:success=>false, message: "Campaign Not updated"}, :status => 422
        end
      end


      def remove_profile_image
        @user = User.find_by_id(params[:id])
        if @user
          @user.remove_file!
          @user.name = ""
          @user.save
          render json:{:success=> true, data: @user, message: "Successfully removed user's profile image", :status => 200}
        else
          render json:{message: "Invalid user ID"} , :status => 422
        end
      end

      #it is not belongs here please move once it is done

      def get_app_url_for_ios
        url = "http://www.peershap.com"
        render json:{:success=> true, data: url, message: "Got url", :status => 200}
      end

      def get_app_url_for_android
        url = "http://www.peershap.com"
        render json:{:success=> true, data: url, message: "Got url", :status => 200}
      end


      private
      def user_params
        the_params = params.require(:user).permit(
          :invite_id,
          :email,
          :name,
          :phone,
          :address,
          :title,
          :password,
          :password_confirmation,
          :state,
          :zip,
          :city,
          :sex,
          :age,
          :race,
          :material_status,
          :profession,
          :first_name,
          :last_name,
          :image,
          :auth_token,
          :active,
          :file_name,
          :file => [:data]
          )
        the_params[:file] = parse_image_data(the_params[:file_name],the_params[:file]) if (the_params[:file].present? && the_params[:file][:data].present?)
        the_params

      end

      def parse_image_data(file_name, base64_file)
        filename = file_name.present? ? file_name.gsub(/[()]/, '').gsub(' ','_').strip : ""
        @tempfile = Tempfile.new(filename)
        @tempfile.binmode
        @tempfile.write Base64.decode64(base64_file["data"]) if base64_file["data"].present?
        @tempfile.rewind
        content_type = `file --mime -b #{@tempfile.path}`.split(";")[0]
        extension = content_type.match(/gif|jpeg|png|jpg|tiff|bmp/).to_s

        if extension.present?
          filename = File.basename( filename, ".*" )
          filename += ".#{extension}"

          ActionDispatch::Http::UploadedFile.new({
            tempfile: @tempfile,
            content_type: content_type,
            filename: filename
            })
        else
          render :json => {message: "Invalid image format"}, :status => 422
        end
      end


      def clean_tempfile
        if @tempfile
          @tempfile.close
          @tempfile.unlink
        end
      end

    end
  end
end

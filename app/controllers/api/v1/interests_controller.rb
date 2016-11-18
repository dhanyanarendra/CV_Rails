class Api::V1::InterestsController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def index
    @interests = Interest.all
    if @interests.present?
      render :json => {success: 'true', message: "Successfully listed all interests", data: @interests}, status:200
    else
      render :json => {success: 'false', message: 'No interests found', data: @interests}, status:200
    end
  end

  def create
    if params[:interest].present?
      @interest = Interest.new(interest_params)
      if @interest.save
        render :json => {success: 'true', message: 'Successfully created interest', data: @interest}, status:200
      else
        render :json => {success: 'false', message: 'Invalid entry'}, status:422
      end
    else
      render json: {success: "false",message: "Fill the empty fields" }, :status => 422
    end
  end

  private

  def interest_params
    params.require(:interest).permit(:name)
  end
end



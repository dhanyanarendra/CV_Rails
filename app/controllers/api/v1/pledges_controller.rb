class Api::V1::PledgesController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def pledge_need
    @user = User.find_by_id params[:id]
    feed = Feed.find_by_id(params[:feed_id])
    pledge(feed) if params["pledge"][:pledged].present?
    unpledged(feed) unless params["pledge"][:pledged].present?
  end

  def get_pledges
    @user = User.find_by_id params[:id]
    if @user.present?
      pledges = Pledge.where('user_contributor_id=? AND pledged=?', @user.id, true).order('updated_at DESC')
      if pledges.present?
        render :json => {success: true, data: GetPledgesJsonBuilder.new(@user, pledges).build_get_pledges, message: "Successfully listed all pledges for the current user"}, :status => 200
      else
        render :json => {success: false, data: pledges, message: "No pledges for the current user"}, :status => 200
      end
    else
      render :json => {success: false, message: "No user found"}, :status => 422
    end
  end

  def update_priority_and_pledge
    @pledge = Pledge.find_by_id params[:pledge_id]
    if !params[:pledge][:priority_done].nil?
      @pledge.priority_done = params[:pledge][:priority_done]
    elsif !params[:pledge][:pledge_done].nil?
      @pledge.pledge_done = params[:pledge][:pledge_done]
    else
      render :json => {success: true, data: @pledge, message: "Nothing to update"}, :status => 200
      return
    end

    if @pledge.save!
      render :json => {success: true, data: @pledge, message: "Successfully update the pledge"}, :status => 200
    else
      render :json => {success: false, data: @pledge, message: "Fail to update pledge"}, :status => 422
    end
  end

  private

  def pledge(feed)
    unless feed.pledges.present? && feed.pledges.map(&:user_contributor_id).include?(@user.id)
      pledge = feed.pledges.build(pledge_params)
      pledge.user_contributor_id = @user.id
      if pledge.save
        pledged_count = feed.pledges.where('pledged=?', true).count
        feed.update_attributes(pledge: true, pledge_count: pledged_count)
        render :json => {success: true, data: PledgeJsonBuilder.new(@user, feed, pledge).build_pledges, message: "Pledged"}, :status => 200
      else
        render :json => {success: false, data: pledge, message: "Not Pledged"}, :status => 422
      end
    else
      unpledged(feed)
    end
  end

  def unpledged(feed)
    pledge = feed.pledges.where(user_contributor_id: @user.id).first
    pledge.update_attributes(pledged: pledge_params[:pledged])
    pledged_count = feed.pledges.where('pledged=?', true).count
    feed.update_attributes(pledge: false, pledge_count: pledged_count)
    render :json => {success: true, data: PledgeJsonBuilder.new(@user, feed, pledge).build_pledges, message: "Unpledged" }, :status =>200
  end

  def pledge_params
    params.require(:pledge).permit(:pledged, :priority_done, :pledge_done)
  rescue
    {}
  end
end

class Api::V1::FeedsController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_action :find_campaign, except: [:get_all_user_for_particular_feed, :index]

  def create
    if params[:feed].present?
      @user = User.find_by_id params[:id]
      if (@user.has_role? :admin) || (@user.has_role? :cordinator)
        @campaign = Campaign.find_by_id params[:campaign_id]
        @feed = @campaign.feeds.build(feeds_params)
        @feed.user_id = @user.id
        @feed.start_time = @feed.start_time.to_time.strftime('%I:%M %p')
        @feed.end_time = @feed.end_time.to_time.strftime('%I:%M %p')
        if @feed.save
          render :json => {success: "true",message:"Successfully created feeds",data: @feed}, :status => 200
        else
          render :json => {success: "false",message:"Invalid entry",errors: @feed.errors},:status => 401
        end
      else
        render :json => {success: "false",message:"User don't have permission"},:status => 401
      end
    else
      render :json => {success: "false",message:"Invalid entry"},:status => 401
    end
  end

  def index
    @user = User.find_by_id params[:id]
    if @user.present?
      @campaign = Campaign.find_by_id params[:campaign_id]
      if @campaign.present?
        @feeds = @campaign.feeds.order('created_at DESC')
        if @feeds.present?
          render :json => {success: "true", message: "Successfully listed all feeds", data: FeedJsonBuilder.new(@feeds, @user).build_feed, campaign: @campaign}, status: 200
        else
          render :json => {success: "false",message:"No feeds found", data: @feeds,campaign: @campaign},status:200
        end
      else
        render :json => {success: "false",message:"No Campaign found"}, status:422
      end
    else
      render :json => {success: "false",message:"No User found"},status:422
    end
  end

  def show
    @feed = @campaign.feeds.where('id=?', params[:id]).first
    if @feed.present?
      render :json => {success: "true",message:"Successfully listed feed",data: @feed},status: 200
    else
      render :json => {success: "false",message:"No feed found for this campaign"},status: 422
    end
  end

  def like_feed
    @feed = Feed.find_by_id(params[:id])
    if (params[:like] == true) || (params[:like] == "true")
      current_user.like!(@feed)
      @feed.update_attributes(like_count: @feed.likes.count)
      render :json => {:success=>true,feed_like: true,data: @feed,message:"Like",:count=>@feed.likes.count}, :status => 200
    else
      current_user.unlike!(@feed)
      @feed.update_attributes(like_count: @feed.likes.count)
      render :json => {:success=>true,feed_like: false,data: @feed, message:"Unlike",:count=>@feed.likes.count}, :status => 200
    end
  end

  def get_all_user_for_particular_feed
    @users = []
    feed = Feed.find_by_id params[:id]
    if feed.present?
      pledges = feed.pledges.where('pledged=?', true)
      if pledges.present?
        list_the_users pledges
        if @users.empty?
          render :json => {:success=>false,data: @users, message:"No users"}, :status => 200
        else
          render :json => {:success=>true,data: @users, message:"Succesfully list the users"}, :status => 200
        end
      else
        render :json => {success: "false",message:"No Pledges found"},status:422
      end
    else
      render :json => {success: "false",message:"No feed found"},status:422
    end
  end

  private

  def find_campaign
    begin
      @campaign = Campaign.find(params[:campaign_id])
    rescue
      render :json => {:success=>false,message: "Invalid campaign"}, :status => 422
    end
  end

  def list_the_users pledges
    pledges.each do |pledge|
      id = pledge.user_contributor_id
      @user = User.find_by_id id
      @users << @user unless @user.nil?
    end
    @users
  end

  def feeds_params
    params.require(:feed).permit(
      :title,
      :quantity,
      :date,
      :start_time,
      :end_time,
      :location,
      :short_description,
      :like_count,
      :pledge,
      :like,
      :priority,
      :done,
      :interest_id
      )
  end

end

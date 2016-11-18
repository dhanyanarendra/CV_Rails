require 'rails_helper'

RSpec.describe Api::V1::FeedsController, :type => :request do

  let(:user) {FactoryGirl.create(:user)}
  let(:campaign) {FactoryGirl.create(:campaign, creator_id: user.id)}
  let(:feed) {FactoryGirl.create(:feed, :user => user, :campaign => campaign)}
  let(:pledge) {FactoryGirl.create(:pledge, :user_contributor_id => user.id, :feed => feed)}
  let(:empty_pledge) {FactoryGirl.create(:pledge, :user_contributor_id => 9999, :feed => feed)}

  let(:request_headers) {
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => user.auth_token
    }
  }

  describe "create" do
    context "Positive Case" do
      it "should create feeds based on campaign" do
        user.add_role :cordinator
        params = {feed: {title: feed.title,
          quantity:feed.quantity,
          interest_id:1,
          date:feed.date,
          start_time:feed.start_time,
          end_time:feed.end_time,
          location:feed.location,
          short_description:feed.short_description,
          pledge:feed.pledge,
          priority:feed.priority,
          done:feed.done}}
        campaign
        post "/api/v1/users/#{user.id}/campaign/#{campaign.id}/feed",params.as_json
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully created feeds")
      end
    end

    context "Negative Case" do
      it "should not create feeds without params" do
        params = {feed: {}}
        campaign
        post "/api/v1/users/#{user.id}/campaign/#{campaign.id}/feed",params.as_json
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(401)
        expect(response_body.keys).to eq(["success", "message"])
        message = response_body["message"]
        expect(message).to eq("Invalid entry")
      end
    end

    context "Negative Case for invalid entry" do
      it "should create feeds based on campaign" do
        user.add_role :cordinator
        params = {feed: {title: feed.title,
          quantity:feed.quantity,
          date:feed.date,
          start_time:feed.start_time,
          end_time:feed.end_time,
          location:"",
          short_description:feed.short_description,
          pledge:feed.pledge,
          priority:feed.priority,
          done:feed.done}}
        campaign
        post "/api/v1/users/#{user.id}/campaign/#{campaign.id}/feed",params.as_json
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(401)
        expect(response_body.keys).to eq(["success", "message", "errors"])
        message = response_body["message"]
        expect(message).to eq("Invalid entry")
      end
    end

    context "User role Case" do
      it "should not create feeds with user role as user" do
        user.add_role :user
        params = {feed: {title: feed.title,
          quantity:feed.quantity,
          date:feed.date,
          start_time:feed.start_time,
          end_time:feed.end_time,
          location:feed.location,
          short_description:feed.short_description,
          pledge:feed.pledge,
          priority:feed.priority,
          done:feed.done}}
        campaign
        post "/api/v1/users/#{user.id}/campaign/#{campaign.id}/feed",params.as_json
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(401)
        expect(response_body.keys).to eq(["success", "message"])
        message = response_body["message"]
        expect(message).to eq("User don't have permission")
      end
    end
  end

  describe "index" do
    context "Positive case" do
      it "should list all feeds" do
        campaign
        feed
        get "/api/v1/users/#{user.id}/campaign/#{campaign.id}/feeds"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data", "campaign"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully listed all feeds")
      end
    end

    context "Negative Case" do
      it "should not list feeds with out feeds" do
        campaign
        get "/api/v1/users/#{user.id}/campaign/#{campaign.id}/feeds"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data", "campaign"])
        message = response_body["message"]
        expect(message).to eq("No feeds found")
      end

      it "should not list feeds without campaign" do
        get "/api/v1/users/#{user.id}/campaign/#{9999}/feeds"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_body.keys).to eq(["success", "message"])
        message = response_body["message"]
        expect(message).to eq("No Campaign found")
      end

      it "should not list feeds without user" do
        get "/api/v1/users/9999/campaign/9999/feeds"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_body.keys).to eq(["success", "message"])
        message = response_body["message"]
        expect(message).to eq("No User found")
      end
    end
  end

  describe "show" do
    context "Positive Case" do
      it "should show feed based on the feed Id" do
        feed
        get "/api/v1/campaign/#{campaign.id}/feeds/#{feed.id}"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success","message","data"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully listed feed")
      end
    end

    context "Negative Case" do
      it "should not show feed with out feed Id" do
        get "/api/v1/campaign/#{campaign.id}/feeds/#{0}"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_body.keys).to eq(["success","message"])
        message = response_body["message"]
        expect(message).to eq("No feed found for this campaign")
      end

      it "should not show feed with out campaign Id" do
        get "/api/v1/campaign/9999/feeds/#{0}"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_body.keys).to eq(["success","message"])
        message = response_body["message"]
        expect(message).to eq("Invalid campaign")
      end
    end
  end

  describe "get_all_user_for_particular_feed" do
    context "Positive Case" do
      it "should list all users based on feed" do
        feed
        pledge
        get "/api/v1/feeds/#{feed.id}/users"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "data", "message"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Succesfully list the users")
      end
    end

    context "Negative Case" do
      it "should not list the users without having pledges for feed" do
        feed
        empty_pledge
        get "/api/v1/feeds/#{feed.id}/users"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "data", "message"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("No users")
      end

      it "should not list the users without having pledges for feed" do
        feed
        get "/api/v1/feeds/#{feed.id}/users"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_body.keys).to eq(["success", "message"])
        message = response_body["message"]
        expect(message).to eq("No Pledges found")
      end
    end


  end

  describe "like_feed" do
    context "like" do
      it "like the feed" do
        like_params = {like: true}
        campaign
        feed
        post "/api/v1/campaign/#{campaign.id}/feeds/#{feed.id}/like", like_params.to_json, request_headers
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "feed_like", "data", "message", "count"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Like")
      end
    end

    context "Unlike" do
      it "unlike the liked feed" do
        like_params = {like: false}
        campaign
        feed
        post "/api/v1/campaign/#{campaign.id}/feeds/#{feed.id}/like", like_params.to_json, request_headers
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "feed_like", "data", "message", "count"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Unlike")
      end
    end
  end
end

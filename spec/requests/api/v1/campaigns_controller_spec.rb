require 'rails_helper'

RSpec.describe Api::V1::CampaignsController, :type => :request do

  let(:user) {FactoryGirl.create(:user)}
  let(:campaign) {FactoryGirl.create(:campaign, creator_id: user.id)}


  describe 'create' do
    context "Positive case" do
      it "should create a campaign" do
        user.add_role :admin
        credentials = {campaign: {candidate_name: campaign.candidate_name, district: campaign.district,state: campaign.state, year: campaign.year , election: campaign.election}}
        post "/api/v1/user/#{user.id}/campaign", credentials.as_json
        response_body = JSON.parse(response.body)
        expect(response_body['status']).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data", "status"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully created campaign")
      end
    end
  end

    context "Negative case" do
      it "should throw error without params" do
        credentials = {campaign: {}}
        post "/api/v1/user/#{user.id}/campaign", credentials
        response_body = JSON.parse(response.body)
        expect(response_body['status']).to eq(401)
        expect(response_body["message"]).to eq("User don't have permission to create")
      end

      it "should throw error if user not having admin role" do
        credentials = {campaign: {}}
        post "/api/v1/user/#{user.id}/campaign", credentials
        response_body = JSON.parse(response.body)
        expect(response_body['status']).to eq(401)
        expect(response_body["message"]).to eq("User don't have permission to create")
      end

      it "should throw error if campaign is fail to create" do
        user.add_role :admin
        credentials = {campaign: {candidate_name: "", district: campaign.district,state: campaign.state, year: campaign.year , election: campaign.election}}
        post "/api/v1/user/#{user.id}/campaign", credentials
        response_body = JSON.parse(response.body)
        expect(response_body['status']).to eq(401)
        expect(response_body["message"]).to eq("Invalid entry")
      end

       it "should throw error if campaign params null" do
        user.add_role :admin
        credentials = {campaign: {}}
        post "/api/v1/user/#{user.id}/campaign", credentials
        response_body = JSON.parse(response.body)
        expect(response_body['status']).to eq(402)
        expect(response_body["message"]).to eq("Fill the empty fields")
      end
    end


  describe 'index' do
    context "Positive case" do
      it"should list all the campaigns created by all users" do
        campaign
        get "/api/v1/campaigns"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully listed campaigns")
      end
    end

    context "Negative case" do
      it "should throw error when no campaigns are found" do
        get "/api/v1/campaigns"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        message = response_body["message"]
        expect(message).to eq("No campaigns found")
      end
    end

  end

  describe 'show' do
    context "positive case" do
      it "should list campaign created by the users" do
        campaign
        get "/api/v1/users/#{user.id}/campaign/#{campaign.id}"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully listed campaign")
      end
    end
    context "negative case" do
      it "should not show campaign with out campaign Id" do
        get "/api/v1/users/#{user.id}/campaign/#{0}"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_body.keys).to eq(["success","message"])
        message = response_body["message"]
        expect(message).to eq("Campaign not found")
      end

      it "should not show campaign with out user" do
        campaign
        get "/api/v1/users/9999/campaign/#{campaign.id}"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_body.keys).to eq(["success","message"])
        message = response_body["message"]
        expect(message).to eq("Invalid user")
      end
    end
  end

  describe 'delete' do
    context "Positive case" do
      it "should delete campaign created by the users" do
        credentials = {campaign: {candidate_name: campaign.candidate_name, district: campaign.district,state: campaign.state, year: campaign.year , election: campaign.election}}
        delete "/api/v1/campaign/#{campaign.id}",credentials.as_json
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "data", "message"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("campaign has been deleted successfully with campaign")
      end
    end

    context "Negative case" do
      it "should  not delete campaign created by the users" do
        delete "/api/v1/campaign/9999"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(402)
        expect(response_body.keys).to eq(["success", "message"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("campaign not found")
      end
    end
  end

  describe "get_campaign_for_user" do
    context "Positive case" do
      it "should list campaign for current user" do
        user.campaign_id = campaign.id
        user.save
        get "/api/v1/users/#{user.id}/get_campaign_for_user"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully listed campaign for user")
      end
    end

    context "Negative case" do
      it "should not get campaign if user not having campaign" do
        get "/api/v1/users/#{user.id}/get_campaign_for_user"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message"])
        message = response_body["message"]
        expect(message).to eq("Campaign not found for current user")
      end
    end
  end
end

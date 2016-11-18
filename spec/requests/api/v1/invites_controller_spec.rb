require 'rails_helper'

RSpec.describe Api::V1::InvitesController, :type => :request do

  let(:campaign) {FactoryGirl.create(:campaign)}
  let(:user) {FactoryGirl.create(:user, campaign: campaign)}
  let(:invite) {FactoryGirl.create(:invite)}
  let(:params)  {{:invite => {email:"sample@gmail.com"}}}

  describe "create" do
    context "Positive Case" do
      it "should create invite" do
        user
        params = {invite: {email: 'test@example.com'}}
        post "/api/v1/users/#{user.id}/invites",params.as_json
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully created invite")
      end
    end

    context "Negative Case" do
      it "should create invite" do
        user
        params = {invite: {}}
        post "/api/v1/users/#{user.id}/invites",params.as_json
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_body.keys).to eq(["success", "message"])
        message = response_body["message"]
        expect(message).to eq("Fill the empty fields")
      end

      it "should throw error without proper params" do
        user
        params = {:invite => {email:"test1234"}}
        post "/api/v1/users/#{user.id}/invites",params.as_json
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_body.keys).to eq(["success", "message", "errors"])
        message = response_body["message"]
        expect(message).to eq("Fail to create invite")
      end
    end
  end

  describe "get" do
    context "Positive Case" do
      it "should list all interests" do
        invite
        get "/api/v1/invites"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully listed Invites")
      end
    end

    context "Negative Case" do
      it "should not list interests" do
        get "/api/v1/invites"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data"])
        message = response_body["message"]
        expect(message).to eq("No invites found")
      end
    end
  end

end

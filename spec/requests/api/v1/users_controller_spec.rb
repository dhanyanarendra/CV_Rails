require 'rails_helper'

RSpec.describe Api::V1::UsersController, :type => :request do

  let(:campaign) {FactoryGirl.create(:campaign)}
  let(:user) {FactoryGirl.create(:user, campaign: campaign)}
  let(:invite) {FactoryGirl.create(:invite)}
  let(:params)  {{:user => {name:"test1234",email:"sample@gmail.com", password: "password123"}}}

  describe 'sign up' do
    context "Positive case" do
      it "should create a user" do
        post "/api/v1/users", params
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data", "campain"])
        data = response_body["user"]
        message = response_body["message"]
        expect(message).to eq("Successfully created user")
      end

      it "should create a cordinator user" do
        cor_params = {:user => {name:"test1234",email:"sample@gmail.com", password: "password123", id: invite.id}}
        post "/api/v1/users", cor_params
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data", "campain"])
        data = response_body["user"]
        message = response_body["message"]
        expect(message).to eq("Successfully created user")
      end
    end

    context "Negative case" do
      it "should throw error without params" do
        user_params = {:user => {}}
        post "/api/v1/users", user_params
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(404)
        expect(response_body.keys).to eq(["success", "message"])
        message = response_body["message"]
        expect(message).to eq("Invalid entry")
      end

      it "should throw error without proper params" do
        user_params = {:user => {name:"test1234"}}
        post "/api/v1/users", user_params
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(404)
        expect(response_body.keys).to eq(["success", "data", "message"])
        message = response_body["message"]
        expect(message).to eq("Fail to create User")
      end
    end
  end

  describe "index" do
    it "should list all the users" do
      user
      get "/api/v1/users"
      response_body = JSON.parse(response.body)
      expect(response.status).to eq(200)
      data = response_body["data"]
      message = response_body["message"]
      expect(message).to eq("Successfully listed users")
    end

    it "should not list the users" do
      get "/api/v1/users"
      response_body = JSON.parse(response.body)
      expect(response.status).to eq(200)
      message = response_body["message"]
      expect(message).to eq("No users found")
    end
  end

  describe "update" do
    context "positive case" do
      it "should be able to edit user details" do
        put "/api/v1/users/#{user.id}", params
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "data", "message"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully updated user")
      end
    end

    context "Negative Case" do
      it "Should throw an error while updating invalid user" do
        put "/api/v1/users/9999", {}
        response_body =JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_body.keys).to eq(["success", "message"])
        message = response_body["message"]
        expect(message).to eq("User not found")
      end

      it "Should throw an error while updating invalid user" do
        update_params = {:user => {name:"test1234",email:"", password: "password123"}}
        put "/api/v1/users/#{user.id}", update_params
        response_body =JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_body.keys).to eq(["success", "error", "message"])
        message = response_body["message"]
        expect(message).to eq("Please fill the empty fields")
      end
    end
  end

  describe "show" do
    context "Positive case" do
      it "should show users based on ID" do
        get "/api/v1/users/#{user.id}", params
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully listed user")
      end
    end
    context "Negative case" do
      it "should throw an error for invalid user" do
        get "/api/v1/users/99999", params
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        message = response_body["message"]
        expect(message).to eq("Invalid user")
      end
    end
  end

  describe "update_user_with_campaign" do
    context "Positive Case" do
      it "update user with campaign" do
        user
        campaign
        put "/api/v1/users/#{user.id}/campaign/#{campaign.id}"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("User has been updated successfully with campaign")
      end
    end

    context "Negative Case" do
      it "do not update user with campaign" do
        user
        put "/api/v1/users/#{user.id}/campaign/9999"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        message = response_body["message"]
        expect(message).to eq("Campaign Not updated")
      end
    end
  end

  describe "delete_user" do
    context "Positive Case" do
      it "should delete user" do
        user
        delete "/api/v1/user/#{user.id}"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully deleted user")
      end
    end

    context "Negative Case" do
      it "should not delete user" do
        delete "/api/v1/user/9999"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(404)
        message = response_body["message"]
        expect(message).to eq("No user found")
      end
    end
  end

  describe "get_cordinators_for_campaign" do
    context "Positive Case" do
      it "get all cordinators for a campaign" do
        campaign
        user.add_role :cordinator
        get "/api/v1/campaign/#{campaign.id}/cordinators"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully listed cordinators")
      end
    end

    context "Negative Case" do
      it "send success false if no cordinators for a campaign" do
        campaign
        user.add_role :cordinator
        user.campaign_id = 2
        user.save
        get "/api/v1/campaign/#{campaign.id}/cordinators"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        message = response_body["message"]
        expect(message).to eq("No cordinators found")
      end
    end
  end

  describe "remove_profile_image" do
    context "Positive Case" do
      it "should remove the profile image" do
        delete "/api/v1/remove_profile_image/#{user.id}"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully removed user's profile image")
      end
    end

    context "Negative Case" do
      it "send success false if no cordinators for a campaign" do
        delete "/api/v1/remove_profile_image/9999"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        message = response_body["message"]
        expect(message).to eq("Invalid user ID")
      end
    end
  end
end

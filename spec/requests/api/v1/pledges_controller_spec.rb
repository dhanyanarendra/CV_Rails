require 'rails_helper'

RSpec.describe Api::V1::PledgesController, :type => :request do
  let(:camaign) {FactoryGirl.create(:campaign)}
  let(:feed) {FactoryGirl.create(:feed, campaign_id: camaign.id)}
  let(:user) {FactoryGirl.create(:user)}
  let(:pledge) {FactoryGirl.create(:pledge, feed_id: feed.id,user_contributor_id: user.id)}


  let(:request_headers) {
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => user.auth_token
    }
  }

  describe "post" do
    context "Pledge" do
      it "should pledge the project" do

        pledge_params =  {"pledge" =>
          {
            "priority_done" => false,
            "pledge_done" => false,
            "pledged" => true
          }
        }
        post "/api/v1/users/#{user.id}/feeds/#{feed.id}/pledge", pledge_params.to_json,request_headers
        expect(response.status).to eq(200)
        response_body =JSON.parse(response.body)
        expect(response_body.keys).to eq(["success", "data", "message"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Pledged")
      end
    end

    context "Unpledge" do
      it "should unpledge the project" do

        pledge_params =  {"pledge" =>
          {
            "priority_done" => false,
            "pledge_done" => false,
            "pledged" => false
          }
        }
        pledge
        post "/api/v1/users/#{user.id}/feeds/#{feed.id}/pledge", pledge_params.to_json,request_headers
        expect(response.status).to eq(200)
        response_body =JSON.parse(response.body)
        expect(response_body.keys).to eq(["success", "data", "message"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Unpledged")
      end
    end

    context "Negative Case" do
      it "should not save pledge without params" do
        pledge_params =  {"pledge" =>
          {
            "priority_done" => false,
            "pledge_done" => true,
            "pledged" => true
          }
        }
        pledge
        post "/api/v1/users/#{user.id}/feeds/#{feed.id}/pledge", pledge_params.to_json,request_headers
        expect(response.status).to eq(200)
        response_body =JSON.parse(response.body)
        expect(response_body.keys).to eq(["success", "data", "message"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Unpledged")
      end
    end
  end

  describe "get_pledges" do
    context "Positive Case" do
      it "get all pledges for user" do
        pledge
        get "/api/v1/users/#{user.id}/pledges"
        expect(response.status).to eq(200)
        response_body =JSON.parse(response.body)
        expect(response_body.keys).to eq(["success", "data", "message"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully listed all pledges for the current user")
      end
    end

    context "Negative Case" do
      it "show error if no pledges found" do
        get "/api/v1/users/#{user.id}/pledges"
        response_body =JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "data", "message"])
        message = response_body["message"]
        expect(message).to eq("No pledges for the current user")
      end

      it "show error if no user found" do
        get "/api/v1/users/9999/pledges"
        response_body =JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_body.keys).to eq(["success", "message"])
        message = response_body["message"]
        expect(message).to eq("No user found")
      end
    end
  end

  describe "update_priority_and_pledge" do
    context "Positive Case" do
      it "update priority in pledges" do
        pledge_params =  {"pledge" =>
          {
            "priority_done" => true
          }
        }
        put "/api/v1/users/#{user.id}/feeds/#{feed.id}/pledges/#{pledge.id}", pledge_params.to_json,request_headers
        response_body =JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "data", "message"])
        message = response_body["message"]
        expect(message).to eq("Successfully update the pledge")
      end

      it "update done in pledges" do
        pledge_params =  {"pledge" =>
          {
            "pledge_done" => true
          }
        }
        put "/api/v1/users/#{user.id}/feeds/#{feed.id}/pledges/#{pledge.id}", pledge_params.to_json,request_headers
        response_body =JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "data", "message"])
        message = response_body["message"]
        expect(message).to eq("Successfully update the pledge")
      end
    end

    context "Negative Case" do
      it "do not update anything if params null" do
        pledge_params =  {"pledge" =>
          {
            "pledge_done" => nil,
            "priority_done" => nil
          }
        }
        put "/api/v1/users/#{user.id}/feeds/#{feed.id}/pledges/#{pledge.id}", pledge_params.to_json,request_headers
        response_body =JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "data", "message"])
        message = response_body["message"]
        expect(message).to eq("Nothing to update")
      end
    end
  end

end

require 'rails_helper'

RSpec.describe Api::V1::InterestsController, :type => :request do

  let(:interest) {FactoryGirl.create(:interest)}

  describe "create" do
    context "Positive Case" do
      it "should create interest" do
        params = {interest: {name: 'My name'}}
        post "/api/v1/interest",params.as_json
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully created interest")
      end
    end

    context "Negative Case" do
      it "should not create interest" do
        params = {interest: {name: ''}}
        post "/api/v1/interest",params.as_json
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_body.keys).to eq(["success", "message"])
        message = response_body["message"]
        expect(message).to eq("Invalid entry")
      end
    end
  end

  describe "index" do
    context "Positive Case" do
      it "should list all interests" do
        interest
        get "/api/v1/interests"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully listed all interests")
      end
    end

    context "Negative Case" do
      it "should not list interests" do
        get "/api/v1/interests"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data"])
        message = response_body["message"]
        expect(message).to eq("No interests found")
      end
    end
  end
end

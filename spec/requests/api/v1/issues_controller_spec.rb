require 'rails_helper'

RSpec.describe Api::V1::IssuesController, :type => :request do

  let(:user) {FactoryGirl.create(:user)}
  let(:no_issue_user) {FactoryGirl.create(:user)}
  let(:issue) {FactoryGirl.create(:issue)}
  let(:user_issue) {FactoryGirl.create(:user_issue,user_id: user.id,issue_id: issue.id)}



  describe 'create' do
    context "Positive case" do
      it "should create a issue" do
        credentials = {issue: {name: issue.name}}
        post "/api/v1/user/#{user.id}/issue", credentials.as_json
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully created issue")
      end
    end

    context "Negative case" do
      it "should throw error without params" do
        credentials = {issue: {}}
        post "/api/v1/user/#{user.id}/issue", credentials
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(402)
        expect(response_body["message"]).to eq("Fill the empty fields")
      end

      it "should throw error if issue fail to create" do
        credentials = {issue: {name: ""}}
        post "/api/v1/user/#{user.id}/issue", credentials
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(401)
        expect(response_body["message"]).to eq("Invalid entry")
      end

      it "should not create issue without user" do
        credentials = {issue: {name: issue.name}}
        post "/api/v1/user/9999/issue", credentials
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_body["message"]).to eq("Invalid user")
      end
    end
  end

  describe 'update_issue_to_user' do
    context 'Positive case' do
      it 'update issues with user' do
        credentials = {issues: {issues_ids: [issue.id]}}
        put "/api/v1/users/#{user.id}/update_issue", credentials.as_json
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully update issue")
      end
    end
  end

  describe 'index' do
    context "Positive case" do
      it "should list all the issues" do
        issue
        get "/api/v1/issues"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully listed issues")
      end
    end

    context "Negative case" do
      it "should not list the issues" do
        get "/api/v1/issues"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "message", "data"])
        message = response_body["message"]
        expect(message).to eq("No issues found")
      end
    end
  end

  describe 'get_issues_for_user' do
    context "Positive Case" do
      it "should get issues of user" do
        issue
        user.issues << issue
        user.save
        get "/api/v1/users/#{user.id}/issues"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "data", "message"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully listed user issues")
      end
    end

    context "Negative Case" do
      it "should not get issue od the user" do
        no_issue_user
        get "/api/v1/users/#{no_issue_user.id}/issues"
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["success", "data", "message"])
        message = response_body["message"]
        expect(message).to eq("No issues found")
      end
    end
  end
end

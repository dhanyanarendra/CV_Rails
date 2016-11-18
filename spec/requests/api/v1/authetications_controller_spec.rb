require 'rails_helper'

RSpec.describe Api::V1::AuthenticationsController, :type => :request do
    let!(:user) { FactoryGirl.create(:user) }

    describe "Authenticate" do
        context "Positive case" do
            it "should return user information for mobile user" do
                user.add_role :user
                login_credentials = {user:{email:user.email , password:user.password}}
                post "/api/v1/authenticate" , login_credentials
                response_body =JSON.parse(response.body)
                expect(response.status).to eq(200)
                expect(response_body["message"]).to eq("Successfully loggedin")
            end
        end

        context "Negative case" do
            it "should return error for invalid username" do
                login_credentials = {user:{email:"invalid username" , password:user.password}}
                post "/api/v1/authenticate" , login_credentials
                response_body =JSON.parse(response.body)
                expect(response.status).to eq(422)
                expect(response_body['message']).to eq("Invalid Email or Password")

            end
            it "should return error for invalid password" do
                user.add_role :user
                login_credentials = {user:{email:user.email , password:"invalid password"}}
                post "/api/v1/authenticate" , login_credentials
                response_body =JSON.parse(response.body)
                expect(response.status).to eq(422)
                expect(response_body['message']).to eq("Invalid Email or Password")
            end

            it "should return error for web user" do
                user.add_role :admin
                login_credentials = {user:{email:user.email , password:"invalid password"}}
                post "/api/v1/authenticate" , login_credentials
                response_body =JSON.parse(response.body)
                expect(response.status).to eq(401)
                expect(response_body['message']).to eq("Email id registered as a Coordinator/Admin")
            end
        end
    end

    describe "Authenticate for web" do
        context "Positive case" do
            it "should return user information for admin" do
                user.add_role :admin
                login_credentials = {user:{email:user.email , password:user.password}}
                post "/api/v1/authenticate_for_web" , login_credentials
                response_body =JSON.parse(response.body)
                expect(response.status).to eq(200)
                expect(response_body["message"]).to eq("Successfully loggedin")
            end

            it "should return user information for cordinator" do
                user.add_role :cordinator
                login_credentials = {user:{email:user.email , password:user.password}}
                post "/api/v1/authenticate_for_web" , login_credentials
                response_body =JSON.parse(response.body)
                expect(response.status).to eq(200)
                expect(response_body["message"]).to eq("Successfully loggedin")
            end
        end

        context "Negative case" do
            it "should return error for invalid username" do
                login_credentials = {user:{email:"invalid username" , password:user.password}}
                post "/api/v1/authenticate_for_web" , login_credentials
                response_body =JSON.parse(response.body)
                expect(response.status).to eq(422)
                expect(response_body['message']).to eq("Invalid Email or Password")

            end
            it "should return error for invalid password" do
                user.add_role :admin
                login_credentials = {user:{email:user.email , password:"invalid password"}}
                post "/api/v1/authenticate_for_web" , login_credentials
                response_body =JSON.parse(response.body)
                expect(response.status).to eq(422)
                expect(response_body['message']).to eq("Invalid Email or Password")
            end

            it "should return error for mobile user" do
                user.add_role :user
                login_credentials = {user:{email:user.email , password:"invalid password"}}
                post "/api/v1/authenticate_for_web" , login_credentials
                response_body =JSON.parse(response.body)
                expect(response.status).to eq(401)
                expect(response_body['message']).to eq("You are not an invited coordinator")
            end
        end
    end
end

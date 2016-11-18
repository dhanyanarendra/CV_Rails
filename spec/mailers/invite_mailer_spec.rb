require "rails_helper"

RSpec.describe InviteMailer, type: :mailer do

  describe "forgot_password" do
    let (:invite) {FactoryGirl.create(:invite)}
    let (:mail) { InviteMailer.invite_user(invite) }

    it "should render the headers" do
      expect(mail.subject).to eq("Sign up for Peershape")
      expect(mail.to).to eq([invite.email])
      expect(mail.from).to eq(["info@peershape.com"])
    end

    it "should render the body" do
      expect(mail.body.encoded).to match("Hello #{invite.first_name}")
    end
  end

end

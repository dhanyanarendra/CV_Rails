class InviteMailer < ActionMailer::Base
  default :from => "info@peershape.com"

  def invite_user(invite)
    @invite = invite
    mail(:to => @invite.email, :subject=>"Sign up for Peershape")
  end
end

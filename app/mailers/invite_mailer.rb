class InviteMailer < ActionMailer::Base
  default from: "ei11065@fe.up.pt"

  def invite_email(user, invited_user_email, league_name)
    @user = user
    @league_name = league_name
    @invited_user_email = invited_user_email
    @url  = "http://localhost:3000/register"
    mail(to: @invited_user_email, subject: 'You have been invited to join Bettr by ' + @user.email + '!')
  end
end

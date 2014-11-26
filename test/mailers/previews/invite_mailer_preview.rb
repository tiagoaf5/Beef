# Preview all emails at http://localhost:3000/rails/mailers/invite_mailer
class InviteMailerPreview < ActionMailer::Preview
  def invite_email
    InviteMailer.invite_email(User.first, 'diogovaznunes@gmail.com', 'asd')
  end
end

# frozen_string_literal: true

# :Basic Mailer for Sending emails for basic actions:
class BasicMailer < ApplicationMailer
  def send_invite(email, test_id)
    @test = LeadershipSurvey.find(test_id)
    @sender = @test.user.name
    subject = "Leadership Survey Invitation from #{@sender}"
    call_mailgun_service_for_survey_invite(email, @sender, subject)
  rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy,
         Net::SMTPSyntaxError, Net::SMTPFatalError,
         Net::SMTPUnknownError
    mail(to: email, subject: "Leadership Survey Invitation from #{@sender}")
  end

  def send_email_to_inviter(inviter_id, invitee_id)
    @inviter = User.find(inviter_id)
    @invitee = User.find(invitee_id)
    subject = "Feedback has been given by #{@invitee.email}"
    call_mailgun_service_for_survey_feedback(@inviter, @invitee, subject)
  rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy,
         Net::SMTPSyntaxError, Net::SMTPFatalError,
         Net::SMTPUnknownError
    mail(to: @inviter.email, subject: "Feedback has been given by #{@invitee.email}")
  end

  def send_excel_user_invite(user, password, invitation_message)
    @user = user
    @password = password
    subject = 'Your credentionals for Leadership'
    call_mailgun_service_for_excel_user(user, password, invitation_message, subject)
  rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy,
         Net::SMTPSyntaxError, Net::SMTPFatalError,
         Net::SMTPUnknownError
    mail(to: @user.email, subject: subject)
  end

  def call_mailgun_service_for_excel_user(user, password, invitation_message, subject)
    Mailgun::EmailService.new(
      user.email,
      subject,
      'excel_user_invite_email',
      template_vars_for_excel_user(user, password, invitation_message)
    ).send_email
  end

  def template_vars_for_excel_user(user, password, invitation_message)
    {
      email: user.email,
      password: password,
      login_url: new_user_session_url,
      invitation_message: invitation_message
    }
  end

  def call_mailgun_service_for_survey_invite(email, sender, subject)
    Mailgun::EmailService.new(
      email,
      subject,
      'email_send_to_invitee',
      template_vars_for_survey_invite(sender)
    ).send_email
  end

  def template_vars_for_survey_invite(sender)
    {
      sender: sender,
      invite_url: user_invites_url
    }
  end

  def call_mailgun_service_for_survey_feedback(inviter, invitee, subject)
    Mailgun::EmailService.new(
      inviter.email,
      subject,
      'send_email_to_inviter',
      template_vars_for_survey_feedback(inviter, invitee)
    ).send_email
  end

  def template_vars_for_survey_feedback(inviter, invitee)
    {
      inviter: inviter.email,
      invitee: invitee.email
    }
  end
end

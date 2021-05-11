# frozen_string_literal: true

module Mailgun
  # :Class for Calling Mailgun Templates:
  class EmailService
    def initialize(to, subject, template_name, template_vars)
      @to = to
      @subject = subject
      @template_name = template_name
      @template_vars = template_vars
    end

    def send_email
      data = {}
      data[:from] = 'Invitation <no-reply@newleadership360.com>'
      data[:to] = @to
      data[:subject] = @subject
      data[:template] = @template_name
      @template_vars.each do |key, value|
        data["v:#{key}"] = value
      end
      RestClient.post "https://api:#{ENV['MAILGUN_API_KEY']}"\
      "@api.mailgun.net/v3/#{ENV['MAILER_DOMAIN']}/messages", data
    end
  end
end

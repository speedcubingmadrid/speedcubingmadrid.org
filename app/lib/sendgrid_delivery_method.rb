class SendgridDeliveryMethod
  def initialize(params)
    puts params
  end

  def deliver!(mail)
    email = SendGrid::Mail.new
    email.from = SendGrid::Email.new(email: mail[:from].addresses.first)
    email.subject = mail.subject
    personalization = SendGrid::Personalization.new
    mail[:to].addresses.each do |addr|
      personalization.add_to(SendGrid::Email.new(email: addr))
    end
    email.add_personalization(personalization)

    # Assumes all our mails have both html and text parts
    email.add_content(SendGrid::Content.new(type: 'text/plain', value: mail.text_part.decoded))
    email.add_content(SendGrid::Content.new(type: 'text/html', value: mail.html_part.decoded))


    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    sg.client.mail._("send").post(request_body: email.to_json)
  end
end

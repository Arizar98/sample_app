Rails.application.configure do
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = {host: "localhost:3000" }

  config.action_mailer.smtp_settings = {
  :user_name => ENV['HOST_NAME'],
  :password => ENV['HOST_PASSWORD'],
  :address => 'smtp.mailtrap.io',
  :domain => 'smtp.mailtrap.io',
  :port => '2525',
  :authentication => :cram_md5
}
end

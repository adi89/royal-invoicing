ActionMailer::Base.smtp_settings = {
    :address   => "smtp.mandrillapp.com",
    :port      => 587, # ports 587 and 2525 are also supported with STARTTLS
    :user_name => "devops@subvrt.mygbiz.com",
    :password  => ENV["MANDRILL_API_KEY"], # SMTP password is any valid API key
    :authentication => 'login', # Mandrill supports 'plain' or 'login'
    :domain => 'light-test.com', # your domain to identify your server when connecting
  }
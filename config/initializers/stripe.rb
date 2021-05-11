Rails.configuration.stripe = {
  :publishable_key => ENV['STRIPE_PUBLISHABLE_KEY'],
  :secret_key      => ENV['STRIPE_SECRET_KEY'],
  :end_point_secret => ENV['STRIPE_ENDPOINT_SECRET']
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]  
Stripe.api_version = '2019-03-14'

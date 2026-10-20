# config/initializers/stripe.rb
Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials.dig(:stripe, :publishable_key),
  secret_key:      Rails.application.credentials.dig(:stripe, :secret_key)
}

# This line informs the Stripe gem to use your secret key
Stripe.api_key = Rails.configuration.stripe[:secret_key]
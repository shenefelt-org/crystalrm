MoneyRails.configure do |config|
  # Default currency (Stripe accepts lower-case or standard ISO 4217)
  config.default_currency = :usd

  # Use round half-up rounding mode
  config.rounding_mode = BigDecimal::ROUND_HALF_UP

  # Include currency column support on monetized models
  config.include_validations = true
end
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # shared rails logging helper for stripe errors
  def log_stripe_error(error, action: "sync")
    # Dynamically uses Customer, Quote, Item, etc based on the model of the error passed in
    Rails.logger.error("Stripe error during #{action} for #{self.class.name} ##{id}: #{error.message}")
    # Add the message to the model's errors list
    errors.add(:base, "Stripe error: #{error.message}")
    false
  end
end
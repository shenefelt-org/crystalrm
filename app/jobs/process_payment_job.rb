class ProcessPaymentJob < ApplicationJob
  queue_as :urgent

  def perform(payment:)
    
  end
end

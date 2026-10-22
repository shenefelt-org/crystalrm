class StripeCustomerService
    @pastel = Pastel.new
    # create the customer on the stripe tenant
    def self.create_customer(customer:)
        return unless customer.present? && customer.stripe_customer_id.nil?

        temp = Stripe::Customer.create(customer.to_stripe)

        customer.update!(
            stripe_customer_id: temp.id
        )
    end

    # update the customers data in the catalog
    def self.update_customer(customer:)
        Stripe::Customer.update(customer.stripe_customer_id, customer.to_stripe)

    rescue Stripe::StripeError => e
        puts @pastel.red.on_white(e.message)
    end

    def self.create_customer_debit(customer:, transaction:)
        return unless customer.present? && customer.stripe_customer_id.present? && transaction.present?
        temp = Stripe::Customer.create_balance_transaction(customer.stripe_customer_id, {
            amount: transaction.amount_cents
            currency: transaction.amount_currency,
            description: transaction.description,
        })

        transaction.update!(
            stripe_balance_transaction_id: temp.id
        )
    end

end
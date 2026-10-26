class StripeCustomerService
    @pastel = Pastel.new
    # create the customer on the stripe tenant 
    def self.create_customer(customer:)
        return unless valid_customer_params?(customer: customer)

        temp = Stripe::Customer.create(customer.to_stripe)

        customer.update!(
            stripe_customer_id: temp.id
        )

        attach_test_visa(customer: customer)
    end

    # update the customers data on model change. (checked at model level update)
    def self.update_customer(customer:)
        # return unless valid_customer_params?(customer: customer)
        Stripe::Customer.update(customer.stripe_customer_id, customer.to_stripe)

    rescue Stripe::StripeError => e
        error(e)
    end

    # delete a stripe customer
    def self.destroy_customer(customer:)
        Stripe::Customer.delete(customer.stripe_customer_id)
        
    end

    def self.update_customer_balance(customer:)
        Stripe::Customer.update(customer.stripe_customer_id, { balance: customer.balance_cents })
    rescue Stripe::InvalidRequestError => e 
        puts @pastel.bold.bright_magenta.on_black("Invalid Request Error: #{e.message}")
        false
    end

    # create a transactional balance debit on the customers account.
    # @param customer - the customer obj to work with
    # @param transaction - the account transaction obj to work with 
    def self.create_customer_debit(customer:, transaction:)
        return unless valid_transaction_params?(customer: customer, transaction: transaction)
        temp = Stripe::Customer.create_balance_transaction(customer.stripe_customer_id, {
            amount: transaction.amount_cents,
            currency: transaction.amount_currency,
            description: transaction.description,
        })

        transaction.update!(
            stripe_balance_transaction_id: temp.id
        )
    end

    # create a transactional balance credit on the customers account
    # @param customer - the customer object to work with
    # @param transaction - the transaction object to work with
    def self.create_customer_credit(customer:, transaction:)
        return unless valid_transaction_params?(transaction: transaction, customer: customer)
        temp = Stripe::Customer.create_balance_transaction(customer.stripe_customer_id, {
            amount: -(transaction.amount_cents), # cast amt cents to negative value to represent credit 
            currency: transaction.amount_currency,
            description: transaction.description
        })

        transaction.update!(
            stripe_balance_transaction_id: temp.id
        )
    end

    # Attach the test visa 4242 as the customers default payment method 
    def self.attach_test_visa(customer:)
        customer.set_payment_processor(:stripe, processor_id: customer.stripe_customer_id)
        pay_method = Stripe::PaymentMethod.attach(
            'pm_card_visa',
            { customer: customer.stripe_customer_id }
        )

        # set default on strpe
        Stripe::Customer.update(
            customer.stripe_customer_id,
            { invoice_settings: { default_payment_method: pay_method.id } }
        )

        # sync
        Pay::Stripe::PaymentMethod.sync(pay_method.id)
    end

    private 
    def self.valid_customer_params?(customer:)
        customer.present? && customer.stripe_customer_id.nil?
    end

    # validate the transaction and customer params are valid for a transaction
    # @param transaction - the transaction object to validate
    # @param customer - the customer object to validate
    def self.valid_transaction_params?(transaction:, customer:)
        transaction.present? && transaction.credit? && valid_customer_params(customer: customer)
    end

    def self.error(event)
        puts @pastel.red.on_white(event)
    end


end
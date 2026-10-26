class Customer < ApplicationRecord
    has_many :projects, dependent: :destroy
    has_many :quotes, dependent: :destroy
    has_many :account_balance_transactions, dependent: :destroy
    has_many :subscriptions, dependent: :destroy

    monetize :balance_cents
    pay_customer default_payment_processor: :stripe

    after_create_commit :create_stripe_customer!
    # after_update :update_stripe_customer, if: :stripe_fields_changed?
    after_update :update_stripe_customer_balance, if: :saved_change_to_balance_cents?
    


    def full_name
        "#{first_name} #{last_name}"
    end

    def active?
        active_customer
    end

    # Cast attr to accepted Stripe Hash
    def to_stripe
        {
            name: full_name,
            email: email, 
            description: description,
            business_name: company_name,
            balance: balance_cents,
            invoice_settings: {
                footer: company_name
            },
            metadata: {
                customer_id: id,
                last_updated_at: updated_at,
                total_subscriptions: subscriptions.count
            }
        }
    end

    def subscription?
        !subscriptions.count.zero?
    end

    private

    def create_stripe_customer!
        return if stripe_customer_id.present?
        payment_processor.customer # ensure the payment processor is created on stripe
        StripeCustomerCreationJob.perform_later(customer: self)
    end

    def update_stripe_customer 
        StripeCustomerUpdateJob.perform_later(customer: self)
    end

    def create_stripe_customer_debt
        UpdateStripeCustomerBalanceJob.create_balance_transaction(customer: self, transaction: account_balance_transactions.last)
    end

    def update_stripe_customer_balance
        return unless stripe_customer_id.present? && saved_change_to_balance_cents?
        UpdateStripeCustomerBalanceJob.perform_later(customer: self)
    end

    def stripe_fields_changed?
        stripe_customer_id.present? && (saved_change_to_first_name? || saved_change_to_last_name? || saved_change_to_email? || saved_change_to_balance_cents? || saved_change_to_description? || saved_change_to_active_customer?)
    end
end

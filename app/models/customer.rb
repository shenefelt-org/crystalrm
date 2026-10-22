class Customer < ApplicationRecord
    has_many :projects, dependent: :destroy
    has_many :quotes, dependent: :destroy
    has_many :account_balance_transactions, dependent: :destroy
    monetize :balance_cents
    pay_customer default_payment_processor: :stripe

    after_update :update_stripe_customer, if: :stripe_fields_changed?


    def full_name
        "#{first_name} #{last_name}"
    end

    # convert the customer to the required hash for the stripe api
    def to_stripe
        {
            name: full_name,
            email: email, 
            description: description,
            business_name: company_name,
            invoice_settings: {
                footer: company_name
            },
            metadata: {
                customer_id: id,
                last_updated_at: updated_at
            }
        }

        UpdateStripeCustomerBalanceJob.perform_later(customer: self) if saved_change_to_balance_cents?
    end

    private

    def update_stripe_customer 
        StripeCustomerUpdateJob.perform_later(customer: self)
    end

    def create_stripe_customer_debt
        StripeCustomerService.create_balance_transaction(customer: self, transaction: account_balance_transactions.last)
    end

    def stripe_fields_changed?
        stripe_customer_id.present? && (saved_change_to_first_name? || saved_change_to_last_name? || saved_change_to_email? || saved_change_to_balance_cents? || saved_change_to_description?)
    end
end

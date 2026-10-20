class Customer < ApplicationRecord
    has_many :projects, dependent: :destroy
    has_many :quotes, dependent: :destroy
    pay_customer default_payment_processor: :stripe


    def full_name
        "#{first_name} #{last_name}"
    end

    private


    def stripe_attributes(customer)
        {
            name: full_name,
            metadata: {
                app_customer_id: id,
                account_level: "standard"
            }
        }
    end
end

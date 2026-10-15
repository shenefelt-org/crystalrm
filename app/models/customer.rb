class Customer < ApplicationRecord
    has_many :projects, dependent: :destroy
    has_many :orders, dependent: :destroy
    has_many :quotes, dependent: :destroy

    after_create_commit :create_stripe_customer!

    # concat the full name from the first and last
    def full_name
        "#{first_name} #{last_name}"
    end

    private

    def create_stripe_customer!
        # fallback validate customer is not in stripe
        return if Stripe::Customer.list(email: email, limit: 1).data.first

        temp = Stripe::Customer.create({
            name: full_name,
            email: email,
            metadata: {
                user_id: id
            }
        })

        update!(
            stripe_customer_id: temp.id
        )

    rescue Stripe::StripeError => e
        puts "nil"
    end

end

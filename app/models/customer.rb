class Customer < ApplicationRecord
    has_many :projects, dependent: :destroy
    has_many :orders, dependent: :destroy

    after_save_commit :create_stripe_customer!
    # concat the full name from the first and last
    def full_name
        "#{first_name} #{last_name}"
    end

    private

    def create_stripe_customer!
        return unless stripe_customer_id.nil?

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

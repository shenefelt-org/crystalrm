class StripeSubscriptionService
    @pastel = Pastel.new
    # Create a new subscription for a customer
    def self.create_subscription(customer:, item:)

        temp = customer.payment_processor.subscribe(
            name: item.plan_name,
            plan: item.stripe_price_id
        )

        customer.subscriptions.create!(
            item: item,
            stripe_subscription_id: temp.processor_id,
            status: temp.status,
            price: item.price,
        )

        puts @pastel.bold.black.on_yellow("Subscription id: #{temp.processor_id} successfully created and assigned to #{customer.full_name}")
    rescue Stripe::CardError => e
        puts @pastel.bold.black.on_yellow("Card Error: #{e.message}")
        false
    rescue Stripe::InvalidRequestError => e
        puts @pastel.bold.black.on_yellow("Invalid request params #{e.message}")
        false
    rescue Stripe::StripeError => e 
        puts @pastel.bold.black.on_yellow("Catch all err #{e.message}")
        false
    end

    def self.get_customer_sub(sub:)
        return unless (sub.present? && sub.stripe_subscription_id.present?)
        Stripe::Subscription.retrieve(sub.stripe_subscription_id)

    rescue Stripe::APIConnectionError => e 
        puts "Api connection failure #{e.message}"
        false 
    rescue Stripe::StripeError => e
        puts "General err #{e.message}"
        false
    end

    def self.sync_stripe_subscriptions
        return if Subscription.count.zero? || Customer.count.zero?

        Stripe::Subscription.list(status: 'all').auto_paging_each do |sub|
            temp = Customer.find_by(stripe_customer_id: sub.customer)
            next unless temp

            item = Item.find_by(stripe_price_id: sub.items.data.first&.price&.id)
            
            local_sub = temp.subscriptions.find_or_initialize_by(
                stripe_subscription_id: sub.id
            )

            local_sub.update!(
                item: item,
                status: sub.status,
                price: item&.price || 0,
            )

            puts @pastel.black.on_magenta("Subscription #{sub.id} synced for #{temp.full_name}")
        end

    end

    def self.update_sub_status(sub:)
        return false unless sub.present?
        temp = Pay::Subscription.find_by(processor_id: sub.stripe_subscription_id)
        
        # attempt to cancel using pay gem else cancel with raw api call
        (temp.present?) ? temp.cancel : Stripe::Subscription.cancel(sub.stripe_subscription_id)

        sub.update!(status: "canceled")
    end

    def self.cancel_subscription_immediate!(subscription:)
        Pay::Stripe::Subscription.find_by(processor_id: subscription.stripe_subscription_id).cancel_now!
        subscription.update!(status: "inactive")
        puts @pastel.bold.black.on_yellow("Cancelled #{subscription.stripe_subscription_id} for #{subscription&.customer.full_name}")
    end


    # validate that the customer and item attrs are set on the model
    # def self.valid_params?(customer:, item:)
    #     (customer.present? && item.present? && customer.stripe_customer_id.present? && item.stripe_product_id.present? && item.stripe_price_id.present?)
    # end

end
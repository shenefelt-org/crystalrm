class StripeService
    # all methods catch the StripeError during transaction - required
    def self.create_stripe_customer(customer:)
        return if customer&.stripe_customer_id.present?
        # protect from duplicate creation on the endpoint
        indempotency_key = "create_stripe_cust_#{customer.id}"

        temp = Stripe::Customer.create({
            name: customer&.full_name,
            email: customer&.email,
            metadata: {
                user_id: customer.id,
                indempotency_key: indempotency_key
            }
        })

        customer.update!(stripe_customer_id: temp.id)

    rescue Stripe::StripeError => e
        false
    end

    # return a stripe customer by email address
    # @param customer - the customer model to find
    def self.get_customer_by_email(customer:)
        Stripe::Customer.list(email: customer.email).first.data
    rescue Stripe::StripeError => e
        false
    end

    # update the stripe customers company name
    # @param customer - the customer to search for by its stripe_customer_id
    def self.update_customer_company_by_stripe_id(customer:)
        return false unless customer&.stripe_customer_id.present?
        Stripe::Customer.update(
            customer.stripe_customer_id,
            {
                company_name: customer.company_name
            }

        )
    rescue Stripe::StripeError => e
        false
    end

    # Delete a stripe customer
    # @param customer - the customer to delete
    def self.delete_stripe_customer(customer:)
        return unless customer.present? && customer.stripe_customer_id.present?
        Stripe::Customer.delete(customer.stripe_customer_id)

    rescue Stripe::StripeError => e
        false
    end

    def self.create_stripe_item(item:)
    end

    def self.update_stripe_item_name(item:)
        return unless item&.stripe_product_id.present?
        Stripe::Product.update(
            item.stripe_product_id, { name: item.name }
        )
    rescue Stripe::StripeError => e
        puts "ERR #{e.message}"
    end

    def self.update_item_price(item:)
        return unless item&.stripe_product_id.present? && item&.stripe_price_id.present?
        # create a fresh stripe price id
        temp = Stripe::Price.create({
            product: item.stripe_product_id,
            unit_amount: item.price.cents,
            currency: item.price.currency.to_s.downcase
        })
    end
    # get a stripe item by item name
    # @param item - the item model to search for
    # @returns nil if no item found in stripe catalog || the item if found
    def self.get_stripe_item_by_name(item:)
        Stripe::Item.list(name: item.name).first.data
    rescue Stripe::StripeError => e
        false
    end

    # get all stripe items
    # @returns all items in the Stripe catalog
    def self.get_all_stripe_items
    end

    # create the stripe item
    # @param item - item datum that should be created.
    def self.make_stripe_item(item:)
        return if item.stripe_product_id.present?

        temp = Stripe::Product.create({
            name: name,
            description: description,
            default_price_data: {
                unit_amount: price.cents,
                currency: price.currency.to_s.downcase
            }
        })

        item.update!(
            stripe_product_id: temp.id,
            stripe_price_id: temp.default_price
        )
    rescue Stripe::StripeError => e
        false
    end

    # get sales data year to date
    # @returns struct {}
    def self.get_sales_data_ytd
    end

    # Create a non-finalized quote
    # @param quote - the quote model that will be used to init the quote.
    # @return nil unless quote is present - idx unique will prevent duplicates
    def self.create_stripe_quote(quote:)
        return unless quote.present?
        # create a map to pass in all the quotes line items; map will reutrn [{}]
        line_items = quote.line_items.map do |li|
            {
                price: li.item.stripe_price_id,
                quantity: li.quantity
            }
        end

        temp = Stripe::Quote.create({
            customer: quote.customer.stripe_customer_id,
            line_items: line_items,
            description: "#{quote.customer.full_name} quote",
            expires_at: 30.days.from_now.to_i,
            header: "#{}"
        })
        # store the non final quote number.
        quote.update!(quote_number: temp.id)
    rescue Stripe::StripeError => e
        puts "Error #{e.message}"
        false
    end

    # Create a finalized quote & Updates Quote Number to the offical finalized quote number
    # @param quote - the quote model that will be used to finalize the quote
    # @return nil unless quote is present
    def self.finalize_stripe_quote(quote:)
        return unless quote&.quote_number.present?
        temp = Stripe::Quote.finalize_quote(quote.quote_number)

        # add offical quote number on finalization add status
        quote.update!(
            status: temp.status
        )

    rescue Stripe::StripeError => e
        false
    end


    def self.list_draft_quotes
    end
end

class StripeWorker
    # all methods catch the StripeError during transaction - required
    def self.create_stripe_customer(customer:)
    end

    # return a stripe customer by email address
    # @param customer - the customer model to find
    def self.get_customer_by_email(customer:)
        Stripe::Customer.list(email: customer.email).first.data
    rescue Stripe::StripeError => e
        log_stripe_error(e, action: "finalize quote")
    end

    def self.create_stripe_item(item:)
    end
    # get a stripe item by item name
    # @param item - the item model to search for
    # @returns nil if no item found in stripe catalog || the item if found
    def self.get_stripe_item_by_name(item:)
        Stripe::Item.list(name: item.name).first.data
    rescue Stripe::StripeError => e
        log_stripe_error(e, action: "finalize quote")
    end

    # get all stripe items
    # @returns all items in the Stripe catalog
    def self.get_all_stripe_items
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
        line_items = quote.line_items.map! do |li|
            {
                price: li.stripe_price_id,
                price_data: {
                    currency: li.unit_price_currency.downcase

                },
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
        log_stripe_error(e, action: "create quote")
    end

    # Create a finalized quote & Updates Quote Number to the offical finalized quote number
    # @param quote - the quote model that will be used to finalize the quote
    # @return nil unless quote is present
    def self.finalize_stripe_quote(quote:)
        return unless quote.present?
        temp = Stripe::Quote.finalize_quote(quote_number)

        # add offical quote number on finalization add status
        quote.update_columns!(
            status: temp.status,
            quote_number: temp.number
        )

    rescue Stripe::StripeError => e
        log_stripe_error(e, action: "finalize quote")
    end


end
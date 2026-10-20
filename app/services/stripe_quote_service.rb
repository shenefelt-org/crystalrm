class StripeQuoteService

    def self.create_inital_quote(quote:)
        return unless quote.present? && quote&.customer.present? && !quote&.line_items.zero?
        s_customer = quote.customer.payment_processor

        # send call to ensure customer (check to make sure it is on the server or lazy create)
        s_customer.customer
        s_cust_id = s_customer.processor_id

        temp = Stripe::Quote.create({
            customer: s_cust_id,
            line_items: map_line_items(quote: quote),
            description: "Quote for - #{quote.customer.full_name}",
            expires_at: 30.days.from_now.to_i
        })

        final = Stripe::Quote.finalize_quote(temp.id)
        quote.update!(
            stripe_quote_id: final.id, # backend api quote id
            quote_number: final.number, # for public e.g. quote numbers on quotes
        )
        final
    rescue Stripe::StripeError => e
        puts "#{e.message}"
    end

    private 

    def map_line_items(quote:)
        return if quote.line_items.zero?
        quote.line_items.map do |line|
            {
                price: line.item.stripe_price_id,
                quantity: line.quantity
            }
        end
    end
end
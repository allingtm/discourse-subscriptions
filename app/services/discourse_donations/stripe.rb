
module DiscourseDonations
  class Stripe
    def initialize(secret_key, opts)
      ::Stripe.api_key = secret_key
      @description = opts[:description]
      @currency = opts[:currency]
    end

    def charge(email, opts)
      customer = ::Stripe::Customer.create(
        email: email,
        source: opts[:source]
      )
      ::Stripe::Charge.create(
        customer: customer.id,
        amount: opts[:amount],
        description: @description,
        currency: @currency
      )
    end
  end
end

require 'stripe'
require_relative 'errors'
module AmdirentStripe::StripeMixin
  extend ActiveSupport::Concern
  included do

    before_create do 
      self.stripe_key = ::Stripe::Customer.create(email: email).id
    end
  end

  def charges
    raise NoCustomerError.new unless stripe_customer
    ::Stripe::Charge.list(customer: stripe_key)
  end

  def plans
    ::Stripe::Plan.list()
  end

  def subscriptions
    raise NoCustomerError.new unless stripe_customer
    ::Stripe::Subscription.list(customer: stripe_key)
  end


  def subscribe_to!(plan)
    raise NoCustomerError.new unless stripe_customer
    raise NoCardError.new unless stripe_customer.default_source

    ::Stripe::Subscription.create(
      :customer => stripe_key,
      :plan => plan.is_a?(String) ? plan : plan.id
    )
  end

  def stripe_customer
    if stripe_key
      begin
        @stripe_customer ||= ::Stripe::Customer.retrieve(stripe_key)

        if(@stripe_customer.deleted?)
          raise NoSuchCustomerError.new
        end

        @stripe_customer
      rescue ::Stripe::InvalidRequestError => e
        if(e.message.match(/No such customer/))
          raise NoSuchCustomerError.new
        end
        raise e
      end
    end
  end

  def cancel_subscription!(id)
    begin
      stripe_customer.subscriptions.retrieve(id).delete
    rescue  ::Stripe::InvalidRequestError => e
      if(e.message.match(/does not have a subscription/))
        raise NoSuchSubscriptionError.new
      end
      raise e
    end
  end

  def has_active_subs?
    subscriptions.data.any? { |sub| !sub.ended_at and !sub.canceled_at }
  end

  def save_card!(tok)
    raise NoCustomerError.new unless stripe_customer
    begin
      stripe_customer.source = tok
      stripe_customer.save
    rescue  ::Stripe::InvalidRequestError => e
      if e.message.match(/No such source/) or e.message.match(/No such token/)
        raise NoSuchCardError
      end
      raise e
    end
  end

  private
  def charge!(amt, desc)
    raise NoCustomerError.new unless stripe_customer
    raise NoCardError.new unless stripe_customer.default_source

    ::Stripe::Charge.create(
      :amount => amt,
      :currency => "usd",
      :customer => stripe_key,
      :description => "Charge for #{email} for #{desc}"
    )
  end

end


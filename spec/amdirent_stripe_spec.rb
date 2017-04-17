require "spec_helper"

require "customer"

RSpec.describe AmdirentStripe, :type => :model do

  let(:user) { Customer.create }

  let(:plan) {
    Stripe::Plan.create(
      :amount => 5000,
      :interval => "month",
      :name => "Bronze business",
      :currency => "usd",
      :id => "bronze-business"
    )
  }
  
  after(:each) { plan.delete }

  after(:each) do
    begin
      user.stripe_customer.delete if user.stripe_customer
    rescue NoSuchCustomerError
      puts "Not deleting since already deleted"
    end
  end

  let(:token) { 
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 3,
        :exp_year => 2018,
        :cvc => "314"
      },
    )
  }

  context :stripe_customer do
    it "creates a new stripe customer for the customer on creation" do
      expect(user.stripe_key).to_not be_nil
    end

    it "returns nil if there is no stripe_key" do
      user.stripe_key = nil
      expect(user.stripe_customer).to be_nil
    end

    it "returns a stripe customer object" do
      expect(user.stripe_customer).to be_a_kind_of(Stripe::Customer)
    end

    it "returns a NoSuchCustomerError if the Stripe Customer was deleted" do
      user.stripe_customer.delete
      expect { user.stripe_customer }.to raise_error(NoSuchCustomerError)
    end
  end

  context :save_card! do
    it "can save a new card for a customer" do
      expect { user.save_card!(token.id) }.to_not raise_error
    end

    it "cant save an invalid card for a customer" do
      expect { user.save_card!("gobbledegook") }.to raise_error(NoSuchCardError)
    end
  end

  context :charge_failure_modes do
    it "cant charge a customer without a card saved" do
      expect { user.send(:charge!, 2000, "Something") }.to raise_error(NoCardError)
    end

    it "cant charge a customer without a customer saved" do
      user.stripe_key = nil
      expect { user.send(:charge!, 2000, "Something") }.to raise_error(NoCustomerError)
    end
  end

  context :subscribe_failure_modes do

    it "cant subscribe a customer without a card saved" do
      expect { user.subscribe_to!(plan) }.to raise_error(NoCardError)
    end

    it "cant show subscriptions when no customer is present" do
      user.stripe_key = nil
      expect { user.subscriptions }.to raise_error(NoCustomerError)
    end

    it "cant cancel a nonexistent subscription" do
      expect { user.cancel_subscription!("blah") }.to raise_error NoSuchSubscriptionError
    end
  end

  context :with_card do
    before(:each) { user.save_card!(token.id) }

    context :charges_a_customer do
      before(:each) {  user.send(:charge!, 2000, "Something") }

      it "has a charge object" do
        expect(user.charges.data.length).to eq(1)
      end

      it "has a charge for that amount in cents" do
        expect(user.charges.data.first.amount).to eq 2000
      end
    end

    it "can charge without errors" do
      expect { user.send(:charge!, 2000, "Something") }.to_not raise_error(NoCardError)
    end

    context :subscribe_to! do

      before(:each) { user.subscribe_to!(plan) }

      it "yields a single subscription" do
        expect(user.subscriptions.data.length).to eq 1
      end

      it "can be cancelled" do
        user.cancel_subscription!(user.subscriptions.data[0].id)

        expect(user.stripe_customer.subscriptions.count).to eq 0
      end
    end

  end

end
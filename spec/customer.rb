require_relative "../lib/amdirent_stripe/stripe_mixin"
class Customer < ActiveRecord::Base
  include AmdirentStripe::StripeMixin
end
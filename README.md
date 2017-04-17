# AmdirentStripe

Contains a mixin for Customer AR models that expects the model to have a stripe_key and an email.
Defines helper methods for charging cards, saving cards, doing charges and subscriptions, etc.
See stripe_mixin.rb for detail.

To use:
`require 'amdirent_stripe/stripe_mixin'


`class Customer < ActiveRecord::Base
  include AmdirentStripe::StripeMixin
end`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'amdirent_stripe'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install amdirent_stripe

## Usage

TODO: Write usage instructions here

## Development

`rspec` to run tests, but make sure you create postgres DB amdirent_stripe_test first, and install a .env file
at the top level containing STRIPE_API_KEY env.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/amdirent_stripe.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'amdirent_stripe/version'

Gem::Specification.new do |spec|
  spec.name          = "amdirent_stripe"
  spec.version       = AmdirentStripe::VERSION
  spec.authors       = ["Jordan Prince"]
  spec.email         = ["jordanmprince@gmail.com"]

  spec.summary       = %q{Stripe Helper methods for models with a stripe_key column.}
  spec.description   = %q{Helpers for Stripe}
  spec.homepage      = "https://github.com/amdirent/amdirent_stripe"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://github.com/amdirent/amdirent_stripe"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pg"
  spec.add_development_dependency "dotenv"
  spec.add_dependency "stripe"
  spec.add_dependency "activerecord"
end

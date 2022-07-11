# Clean

`Clean` is my subjective Ruby adaptation of The Clean Architecture that brings a few PORO modules and classes:

- `Sentry` is the first simple module for checking arguments; its straight purpose is to check and return the value or raise `ArgumentError` when it is invalid.
- `Validator` plays together with `Sentry` and provides the ability to build complex validation scenarios for a few arguments by a few sentries.
- `Service` is just simplest possible "Interactor", "Use Case",  "ServiceObject", or similar.
- `ServiceChain` expands basic `Service` and brings the ability to combine a few services in one chain of calls with a shared context of parameters.
- `ServiceAdapter` is brand new and the most interesting one for me, it provides the ability to "adapt" domain services for particular interfaces (Web, CLI, queues, etc.).
- `Gateway` is an abstraction for placing logic external to the domain, like data storage, message broker, API of external systems, etc.
- And finally `Port` which lives near `Gateway` in the same source file, is some kind of a wrapper for `Gateway` that can be used to plug gateways to services through ports in some kind "standard way".

Boost your code architecture by using Clean's basic concepts. Spree your productivity by entrusting tedious work to [Punch]().

To get more information see its actual source code and tests.

## Installation and Usage

Clean is not supposed to be used as a regular ruby gem, one rather will prefer to copy raw sources to your projects and extend it in accord with one's goals.

You can see it "in action" by using [Punch]() which provides some code generators based on Clean and copies its source code into your code-base.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/clean.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

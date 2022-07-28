# Clean

Boost your code architecture by using Clean. Spree your productivity by entrusting tedious work to [Punch](https://github.com/nvoynov/punch).

`Clean` is my subjective Ruby adaptation of The Clean Architecture that brings a few PORO modules and classes:

- `Clean::Sentry` is the first simple module for checking arguments; its straight purpose is to check and return the value or fail/raise `ArgumentError` when it is invalid.
- `Clean::Service` is simplest possible "Interactor", "Use Case",  "ServiceObject", or similar object designed to "succeed or failure".
- `Clean::Entity` is just simplest possible entity that just point out the concept of stored data (it just a constant with `id` attribute.)
- `Clean::Gateway` is an abstraction for placing logic external to the domain, like data storage, message broker, API of external systems, etc. (see also [Porting Gateways](#porting-gateways))

There are also a few extra "near the subject" abstractions placed at `Clean::Extra`. These are potential candidates but their value has not been proven at the moment.

- `Clean::Extra::Value` that server for ValueObject.
- `Clean::Extra::Chain` expands basic `Service` for the ability to combine a few services in one chain of calls with a shared context of parameters.
- `Clean::Extra::Adapter` provides the ability to "adapt" domain services for particular interfaces (Web, CLI, queues, etc.).
- `Clean::Extra::Validator` plays with `Sentry` providing the ability to build complex validation scenarios.


- And finally `Port` which lives near `Gateway` in the same source file, is some kind of a wrapper for `Gateway` that can be used to plug gateways to services through ports in some kind "standard way".


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

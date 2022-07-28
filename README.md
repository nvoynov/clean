# Clean

Boost your code architecture by using Clean. Spree your productivity by entrusting tedious work to [Punch](https://github.com/nvoynov/punch).

`Clean` is my subjective Ruby adaptation of The Clean Architecture that brings a few PORO modules and classes:

- `Clean::Sentry` is the first simple module for checking arguments; its straight purpose is to check and return the value or fail/raise `ArgumentError` when it is invalid.
- `Clean::Service` is simplest possible "Interactor", "Use Case",  "ServiceObject", or similar object designed to "succeed or failure".
- `Clean::Entity` is just simplest possible entity that just point out the concept of stored data (it just a constant with `id` attribute.)
- `Clean::Value` for ValueObject.
- `Clean::Storage` that serves as basic entity storage interface for __what__?
- `Clean::Gateway` is an abstraction for placing logic external to the domain, like data storing, messaging, calling external systems, etc.

There are also a few extra "near the subject" abstractions placed in `clean/extra` but shared `Clean::` namespace. These are potential candidates but their value has not been proven at the moment.

- `Clean::HashStorage` the simple in-memory storage implementation of `Clean::Storage`.
- `Clean::Chain` expands basic `Service` for the ability to combine a few services in one chain of calls with a shared context of parameters.
- `Clean::Adapter` provides the ability to "adapt" domain services for particular interfaces like Web, CLI, queues, etc.
- `Clean::Validator` plays with `Sentry` providing the ability to build complex validation scenarios.

## Installation

It can be installed manually:

    $ git clone https://github.com/nvoynov/clean.git
    $ cd clean
    $ bundle
    $ rake install

Or you can add it through your application's Gemfile:

```ruby
gem "clean", "~> 0.1.0", git: "https://github.com/nvoynov/clean.git"
```

And then execute:

    $ bundle install

In case you would decide to try [Punch](https://github.com/nvoynov/punch.git), you can skip this step and run `$ punch clone clean` that will copy Clean's sources into your project lib.

## Usage

Don't know what to say here actually, so I's rather give you some examples of usage and again through [Punch](https://github.com/nvoynov/punch.git) source code.

### Sentry

Punch is scarce for sentries because its main input is array of strings (ARGV). Those can be found in [lib/punch/sentries.rb](https://github.com/nvoynov/punch/blob/master/lib/punch/sentries.rb)

### Service

Punch base service ([lib/punch/services/service.rb](https://github.com/nvoynov/punch/blob/master/lib/punch/services/service.rb)) is inherited from `Clean::Service` and the reason to create such one was to have some "rich" base service with connected gateways and a few gadgets.

### Gateway

There are three gateways in Punch - [Storage](https://github.com/nvoynov/punch/blob/master/lib/punch/gateways/storage.rb), [Playbox](https://github.com/nvoynov/punch/blob/master/lib/punch/gateways/playbox.rb), [Preview](https://github.com/nvoynov/punch/blob/master/lib/punch/gateways/preview.rb), and [Logr](https://github.com/nvoynov/punch/blob/master/lib/punch/gateways/logr.rb).

The `Storage` is the simplest one that serves for getting erb-templates outside Punch. The `Playbox` plays for interactions with "punched" project (`Dir.pwd`) providing mainly abilities to read and write sources inside the project.

The `Preview` is actually `Playbox` that instead of writing sources puts it content to STDOUT, and it created the last moment to provide real preview experience where existing sources matters (at the beginning, preview was punching source inside temp folder and existing sources do not matter because have not existed there).

Finally, the `Logr` appeared at the last moment as a gateway because of gateway's easy-porting abilities (look at [lib/punch/gateways.rb](https://github.com/nvoynov/punch/blob/master/lib/punch/gateways.rb))

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and questions are welcome on GitHub at https://github.com/nvoynov/clean.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

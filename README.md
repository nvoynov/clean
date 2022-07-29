# Clean

Boost your code architecture by using Clean. Spree your productivity by entrusting tedious work to [Punch](https://github.com/nvoynov/punch).

## Overview

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

Punch is an usual plain Ruby Gem with no trick inside so it can be installed in usual way, manually

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

**But** unless you develop a simple script, I'd rather suggest another way. Clean is just a small set of core "starter" concepts of an application; every application evolves as time goes and these concepts might also evolve along. That's why the more natural way would be just copying it inside your `lib` folder. And this stuff can be easily done with [Punch](https://github.com/nvoynov/punch.git) - just run `$ punch clone clean` that will do the work for you.

## Usage

Just a few words here. You can see the docs (run `yardoc`) where I sketched out some examples of usage for each of these concepts individually. And below you can find a few real examples of applying some of those through [Punch](https://github.com/nvoynov/punch.git) source code.

### Sentry

Punch is scarce for sentries because its main input is array of strings (ARGV). Those can be found in [lib/punch/sentries.rb](https://github.com/nvoynov/punch/blob/master/lib/punch/sentries.rb)

### Service

Punch base service is ([lib/punch/services/service.rb](https://github.com/nvoynov/punch/blob/master/lib/punch/services/service.rb)). It inherited from `Clean::Service` and the reason was just to have some "rich" base service with connected a few gateways and gadgets.

### Gateway

There are three gateways in Punch - [Storage](https://github.com/nvoynov/punch/blob/master/lib/punch/gateways/storage.rb), [Playbox](https://github.com/nvoynov/punch/blob/master/lib/punch/gateways/playbox.rb), [Preview](https://github.com/nvoynov/punch/blob/master/lib/punch/gateways/preview.rb), and [Logr](https://github.com/nvoynov/punch/blob/master/lib/punch/gateways/logr.rb).

The `Storage` is the simplest one (and maybe extraneous actually) that serves for getting punch erb-templates. The `Playbox` plays for interactions with the "punched" project (`Dir.pwd`) used mainly for reading and writing sources inside the project. The `Preview` is actually inherited from `Playbox` that overrides #write to put sources to STDOUT instead of writing to disk.

Finally, the `Logr` appeared at the last moment as a gateway because of its (gateway) easy-porting interface (look at [lib/punch/gateways.rb](https://github.com/nvoynov/punch/blob/master/lib/punch/gateways.rb)).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and questions are welcome on GitHub at https://github.com/nvoynov/clean.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

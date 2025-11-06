# Kanjika

Kanjika is a simple Ruby gem for conjugating Japanese verbs. It provides an easy-to-use interface for getting the polite, plain, te, and potential forms of verbs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kanjika'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install kanjika
```

## Usage

To use Kanjika, simply create a new `Kanjika::Verb` object and call the desired conjugation method.

```ruby
require 'kanjika'

verb = Kanjika.verb('書く')

# Get the masu form
verb.conjugate(:masu) # => "書きます"

# Get the te form
verb.conjugate(:te) # => "書いて"

# Get the potential form
verb.conjugate(:potential) # => "書ける"
```

### Negative Forms

You can also get the negative form of a conjugation by passing `negative: true` to the `conjugate` method.

```ruby
verb = Kanjika.verb('食べる')

verb.conjugate(:masu, negative: true) # => "食べません"
verb.conjugate(:te, negative: true) # => "食べなくて"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fagnerpereira/kanjika_gem.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

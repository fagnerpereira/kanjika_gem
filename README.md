# Kanjika

A practical Ruby gem for Japanese verb conjugation. Kanjika provides an easy-to-use interface for conjugating Japanese verbs across multiple forms including masu (polite), te, and potential forms.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kanjika'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install kanjika
```

## Features

- 🎌 Japanese verb conjugation (multiple forms)
- 📝 Support for all verb types: Godan (五段), Ichidan (一段), and Irregular verbs
- 🔄 Multiple conjugation forms: te-form, masu-form, potential
- 🎯 Simple and intuitive API
- ⚡ Built on top of Ve and Mojinizer for accurate morphological analysis

## Usage

### Basic Conjugation

Kanjika provides two main ways to conjugate verbs:

#### Using the module-level method

```ruby
require 'kanjika'

# Conjugate directly
Kanjika.conjugate("食べる", :masu)  # => "食べます"
Kanjika.conjugate("書く", :te)      # => "書いて"

# Negative forms
Kanjika.conjugate("食べる", :masu, negative: true)  # => "食べません"
Kanjika.conjugate("食べる", :te, negative: true)    # => "食べなくて"
```

#### Using the Verb object

```ruby
verb = Kanjika.verb('書く')

# Get the masu form
verb.conjugate(:masu)      # => "書きます"
verb.to(:masu)             # => "書きます" (alias)

# Get the te form
verb.conjugate(:te)        # => "書いて"

# Get the potential form
verb.conjugate(:potential) # => "書ける"

# Negative forms
verb.conjugate(:masu, negative: true)  # => "書きません"
verb.conjugate(:te, negative: true)    # => "書かなくて"
```

### Supported Conjugation Forms

#### Masu Form (Polite Present)

```ruby
Kanjika.conjugate("食べる", :masu)    # => "食べます"
Kanjika.conjugate("書く", :masu)      # => "書きます"
Kanjika.conjugate("する", :masu)      # => "します"

# Negative
Kanjika.conjugate("食べる", :masu, negative: true)  # => "食べません"
```

#### Te Form (Conjunctive)

```ruby
Kanjika.conjugate("食べる", :te)      # => "食べて"
Kanjika.conjugate("書く", :te)        # => "書いて"
Kanjika.conjugate("飲む", :te)        # => "飲んで"
Kanjika.conjugate("買う", :te)        # => "買って"

# Negative
Kanjika.conjugate("食べる", :te, negative: true)    # => "食べなくて"
```

#### Potential Form (Can do)

```ruby
Kanjika.conjugate("食べる", :potential)  # => "食べられる"
Kanjika.conjugate("書く", :potential)    # => "書ける"
Kanjika.conjugate("飲む", :potential)    # => "飲める"
Kanjika.conjugate("する", :potential)    # => "できる"
```

### Verb Types

Kanjika handles all three types of Japanese verbs:

#### Godan Verbs (五段動詞)

Verbs that end in u-column sounds. Examples:

- 書く (kaku) - to write
- 飲む (nomu) - to drink
- 買う (kau) - to buy
- 話す (hanasu) - to speak

#### Ichidan Verbs (一段動詞)

Verbs that end in -eru or -iru. Examples:

- 食べる (taberu) - to eat
- 見る (miru) - to see
- 起きる (okiru) - to wake up

#### Irregular Verbs

Only two main irregular verbs:

- する (suru) - to do
- 来る (kuru) - to come

### Examples

```ruby
# 食べる (taberu - to eat) - Ichidan
verb = "食べる"
Kanjika.conjugate(verb, :masu)       # => "食べます"
Kanjika.conjugate(verb, :te)         # => "食べて"
Kanjika.conjugate(verb, :potential)  # => "食べられる"

# 書く (kaku - to write) - Godan
verb = "書く"
Kanjika.conjugate(verb, :masu)       # => "書きます"
Kanjika.conjugate(verb, :te)         # => "書いて"
Kanjika.conjugate(verb, :potential)  # => "書ける"

# する (suru - to do) - Irregular
verb = "する"
Kanjika.conjugate(verb, :masu)       # => "します"
Kanjika.conjugate(verb, :te)         # => "して"
Kanjika.conjugate(verb, :potential)  # => "できる"
```

## Development

After checking out the repo, run:

```bash
bundle install
```

Run the tests:

```bash
bundle exec rspec
```

Run the linter:

```bash
bundle exec standardrb
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fagnerpereira/kanjika_gem.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

Built with:

- [Ve](https://github.com/kimtaro/ve) - Japanese morphological analyzer
- [Mojinizer](https://github.com/ikayzo/mojinizer) - Japanese character utilities

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
<<<<<<< HEAD
Kanjika.conjugate("食べる", :masu)  # => "食べます"
Kanjika.conjugate("書く", :te)      # => "書いて"

# Negative forms
Kanjika.conjugate("食べる", :masu, negative: true)  # => "食べません"
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
=======
Kanjika.conjugate("食べる", :masu)  # => "食べます" (tabemasu - eat/will eat)
Kanjika.conjugate("書く", :te)      # => "書いて" (kaite - write and...)

# Negative forms
Kanjika.conjugate("食べる", :masu, negative: true)  # => "食べません" (tabemasen - don't eat)
Kanjika.conjugate("食べる", :te, negative: true)    # => "食べなくて" (tabenakute - not eating/without eating)
```

#### Using the Verb object

```ruby
verb = Kanjika.verb('書く')

# Get the masu form (polite present/future)
verb.conjugate(:masu)      # => "書きます" (kakimasu - write/will write)
verb.to(:masu)             # => "書きます" (alias)

# Get the te form (connective)
verb.conjugate(:te)        # => "書いて" (kaite - write and...)

# Get the potential form (can do)
verb.conjugate(:potential) # => "書ける" (kakeru - can write)

# Negative forms
verb.conjugate(:masu, negative: true)  # => "書きません" (kakimasen - don't write)
verb.conjugate(:te, negative: true)    # => "書かなくて" (kakanakute - not writing/without writing)
```

### Supported Conjugation Forms

#### Masu Form (Polite Present)

```ruby
Kanjika.conjugate("食べる", :masu)    # => "食べます" (tabemasu - eat/will eat)
Kanjika.conjugate("書く", :masu)      # => "書きます" (kakimasu - write/will write)
Kanjika.conjugate("する", :masu)      # => "します" (shimasu - do/will do)

# Negative
Kanjika.conjugate("食べる", :masu, negative: true)  # => "食べません" (tabemasen - don't eat)
>>>>>>> 72e54f1e56919054f33fb963f451a3b165e4b027
```

#### Te Form (Conjunctive)

```ruby
<<<<<<< HEAD
Kanjika.conjugate("食べる", :te)      # => "食べて"
Kanjika.conjugate("書く", :te)        # => "書いて"
Kanjika.conjugate("飲む", :te)        # => "飲んで"
Kanjika.conjugate("買う", :te)        # => "買って"

# Negative
Kanjika.conjugate("食べる", :te, negative: true)    # => "食べなくて"
=======
Kanjika.conjugate("食べる", :te)      # => "食べて" (tabete - eat and...)
Kanjika.conjugate("書く", :te)        # => "書いて" (kaite - write and...)
Kanjika.conjugate("飲む", :te)        # => "飲んで" (nonde - drink and...)
Kanjika.conjugate("買う", :te)        # => "買って" (katte - buy and...)

# Negative
Kanjika.conjugate("食べる", :te, negative: true)    # => "食べなくて" (tabenakute - not eating/without eating)
>>>>>>> 72e54f1e56919054f33fb963f451a3b165e4b027
```

#### Potential Form (Can do)

```ruby
<<<<<<< HEAD
Kanjika.conjugate("食べる", :potential)  # => "食べられる"
Kanjika.conjugate("書く", :potential)    # => "書ける"
Kanjika.conjugate("飲む", :potential)    # => "飲める"
Kanjika.conjugate("する", :potential)    # => "できる"
=======
Kanjika.conjugate("食べる", :potential)  # => "食べられる" (taberareru - can eat)
Kanjika.conjugate("書く", :potential)    # => "書ける" (kakeru - can write)
Kanjika.conjugate("飲む", :potential)    # => "飲める" (nomeru - can drink)
Kanjika.conjugate("する", :potential)    # => "できる" (dekiru - can do)
>>>>>>> 72e54f1e56919054f33fb963f451a3b165e4b027
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

<<<<<<< HEAD
=======
## Pronunciation Guide

To help beginners, we're adding pronunciation guides for the kanji used in this documentation and in the code.

- **食べる (taberu):** to eat
- **書く (kaku):** to write
- **飲む (nomu):** to drink
- **買う (kau):** to buy
- **話す (hanasu):** to speak
- **見る (miru):** to see
- **起きる (okiru):** to wake up
- **する (suru):** to do
- **来る (kuru):** to come
- **五段 (godan):** five-step (verb type)
- **一段 (ichidan):** one-step (verb type)

>>>>>>> 72e54f1e56919054f33fb963f451a3b165e4b027
### Examples

```ruby
# 食べる (taberu - to eat) - Ichidan
verb = "食べる"
<<<<<<< HEAD
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
=======
Kanjika.conjugate(verb, :masu)       # => "食べます" (tabemasu - eat/will eat)
Kanjika.conjugate(verb, :te)         # => "食べて" (tabete - eat and...)
Kanjika.conjugate(verb, :potential)  # => "食べられる" (taberareru - can eat)

# 書く (kaku - to write) - Godan
verb = "書く"
Kanjika.conjugate(verb, :masu)       # => "書きます" (kakimasu - write/will write)
Kanjika.conjugate(verb, :te)         # => "書いて" (kaite - write and...)
Kanjika.conjugate(verb, :potential)  # => "書ける" (kakeru - can write)

# する (suru - to do) - Irregular
verb = "する"
Kanjika.conjugate(verb, :masu)       # => "します" (shimasu - do/will do)
Kanjika.conjugate(verb, :te)         # => "して" (shite - do and...)
Kanjika.conjugate(verb, :potential)  # => "できる" (dekiru - can do)
>>>>>>> 72e54f1e56919054f33fb963f451a3b165e4b027
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

<<<<<<< HEAD
=======
## Roadmap

Here are some of the features we're planning to add to Kanjika:

- **More Conjugation Forms:** We'll be adding support for more conjugation forms, such as:
  - Passive (e.g., 食べられる - taberareru)
  - Causative (e.g., 食べさせる - tabesaseru)
  - Volitional (e.g., 食べよう - tabeyou)
  - Imperative (e.g., 食べろ - tabero)
- **Adjective Conjugation:** Support for i-adjectives and na-adjectives.
- **Verb Transitivity:** The ability to identify if a verb is transitive or intransitive.
- **Kanji Pronunciation:** We will add comments to the code to help beginners with the pronunciation of unknown kanji.
- **Web Interface:** A simple web interface to demonstrate the gem's capabilities.

>>>>>>> 72e54f1e56919054f33fb963f451a3b165e4b027
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

Built with:

- [Ve](https://github.com/kimtaro/ve) - Japanese morphological analyzer
- [Mojinizer](https://github.com/ikayzo/mojinizer) - Japanese character utilities

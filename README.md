# Kanjika

A practical Ruby gem for Japanese verb conjugation. Kanjika provides an easy-to-use interface for conjugating Japanese verbs across multiple forms including masu (polite), te, and potential forms.

## Installation

### System Requirements

Kanjika requires **MeCab** (a Japanese morphological analyzer) to be installed on your system.

**Ubuntu/Debian:**
```bash
sudo apt-get install mecab libmecab-dev mecab-ipadic-utf8
```

**macOS:**
```bash
brew install mecab mecab-ipadic
```

**Other systems:** Please refer to the [MeCab installation guide](https://taku910.github.io/mecab/).

### Gem Installation

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
- 📝 Support for all verb types: Godan (五段 / ごだん), Ichidan (一段 / いちだん), and Irregular verbs
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
Kanjika.conjugate("食べる", :masu)  # => "食べます" (たべます / tabemasu - eat/will eat)
Kanjika.conjugate("書く", :te)      # => "書いて" (かいて / kaite - write and...)

# Negative forms
Kanjika.conjugate("食べる", :masu, negative: true)  # => "食べません" (たべません / tabemasen - don't eat)
Kanjika.conjugate("食べる", :te, negative: true)    # => "食べなくて" (たべなくて / tabenakute - not eating/without eating)
```

#### Using the Verb object

```ruby
verb = Kanjika.verb('書く') # 書く = かく (kaku - to write)

# Get the masu form (polite present/future)
verb.conjugate(:masu)      # => "書きます" (かきます / kakimasu - write/will write)
verb.to(:masu)             # => "書きます" (alias)

# Get the te form (connective)
verb.conjugate(:te)        # => "書いて" (かいて / kaite - write and...)

# Get the potential form (can do)
verb.conjugate(:potential) # => "書ける" (かける / kakeru - can write)

# Negative forms
verb.conjugate(:masu, negative: true)  # => "書きません" (かきません / kakimasen - don't write)
verb.conjugate(:te, negative: true)    # => "書かなくて" (かかなくて / kakanakute - not writing/without writing)
```

### Supported Conjugation Forms

#### Masu Form (Polite Present)

```ruby
Kanjika.conjugate("食べる", :masu)    # => "食べます" (たべます / tabemasu - eat/will eat)
Kanjika.conjugate("書く", :masu)      # => "書きます" (かきます / kakimasu - write/will write)
Kanjika.conjugate("する", :masu)      # => "します" (shimasu - do/will do)

# Negative
Kanjika.conjugate("食べる", :masu, negative: true)  # => "食べません" (たべません / tabemasen - don't eat)
```

#### Te Form (Conjunctive)

```ruby
Kanjika.conjugate("食べる", :te)      # => "食べて" (たべて / tabete - eat and...)
Kanjika.conjugate("書く", :te)        # => "書いて" (かいて / kaite - write and...)
Kanjika.conjugate("飲む", :te)        # => "飲んで" (のんで / nonde - drink and...)
Kanjika.conjugate("買う", :te)        # => "買って" (かって / katte - buy and...)

# Negative
Kanjika.conjugate("食べる", :te, negative: true)    # => "食べなくて" (たべなくて / tabenakute - not eating/without eating)
```

#### Potential Form (Can do)

```ruby
Kanjika.conjugate("食べる", :potential)  # => "食べられる" (たべられる / taberareru - can eat)
Kanjika.conjugate("書く", :potential)    # => "書ける" (かける / kakeru - can write)
Kanjika.conjugate("飲む", :potential)    # => "飲める" (のめる / nomeru - can drink)
Kanjika.conjugate("する", :potential)    # => "できる" (dekiru - can do)
```

### Verb Types

Kanjika handles all three types of Japanese verbs:

#### Godan Verbs (五段動詞 / ごだんどうし)

Verbs that end in u-column sounds. Examples:

- 書く (かく / kaku) - to write
- 飲む (のむ / nomu) - to drink
- 買う (かう / kau) - to buy
- 話す (はなす / hanasu) - to speak

#### Ichidan Verbs (一段動詞 / いちだんどうし)

Verbs that end in -eru or -iru. Examples:

- 食べる (たべる / taberu) - to eat
- 見る (みる / miru) - to see
- 起きる (おきる / okiru) - to wake up

#### Irregular Verbs

Only two main irregular verbs:

- する (suru) - to do
- 来る (くる / kuru) - to come

## Pronunciation Guide

To help beginners, we're adding pronunciation guides for the kanji used in this documentation and in the code. Each entry below shows the kanji, its furigana (kana reading), and its romaji.

- **食べる (たべる / taberu):** to eat
- **書く (かく / kaku):** to write
- **飲む (のむ / nomu):** to drink
- **買う (かう / kau):** to buy
- **話す (はなす / hanasu):** to speak
- **見る (みる / miru):** to see
- **起きる (おきる / okiru):** to wake up
- **する (suru):** to do
- **来る (くる / kuru):** to come
- **五段 (ごだん / godan):** five-step (verb type)
- **一段 (いちだん / ichidan):** one-step (verb type)

### Examples

```ruby
# 食べる (たべる / taberu - to eat) - Ichidan
verb = "食べる"
Kanjika.conjugate(verb, :masu)       # => "食べます" (たべます / tabemasu - eat/will eat)
Kanjika.conjugate(verb, :te)         # => "食べて" (たべて / tabete - eat and...)
Kanjika.conjugate(verb, :potential)  # => "食べられる" (たべられる / taberareru - can eat)

# 書く (かく / kaku - to write) - Godan
verb = "書く"
Kanjika.conjugate(verb, :masu)       # => "書きます" (かきます / kakimasu - write/will write)
Kanjika.conjugate(verb, :te)         # => "書いて" (かいて / kaite - write and...)
Kanjika.conjugate(verb, :potential)  # => "書ける" (かける / kakeru - can write)

# する (suru - to do) - Irregular
verb = "する"
Kanjika.conjugate(verb, :masu)       # => "します" (shimasu - do/will do)
Kanjika.conjugate(verb, :te)         # => "して" (shite - do and...)
Kanjika.conjugate(verb, :potential)  # => "できる" (dekiru - can do)
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

## Roadmap

See [ROADMAP.md](ROADMAP.md) for the full list of proposed features awaiting discussion.

Here are some of the features we're planning to add to Kanjika:

- **More Conjugation Forms:** We'll be adding support for more conjugation forms, such as:
  - Passive (e.g., 食べられる (たべられる) - taberareru)
  - Causative (e.g., 食べさせる (たべさせる) - tabesaseru)
  - Volitional (e.g., 食べよう (たべよう) - tabeyou)
  - Imperative (e.g., 食べろ (たべろ) - tabero)
- **Adjective Conjugation:** Support for i-adjectives and na-adjectives.
- **Verb Transitivity:** The ability to identify if a verb is transitive or intransitive.
- **Kanji Pronunciation:** We will add comments to the code to help beginners with the pronunciation of unknown kanji.
- **Web Interface:** A simple web interface to demonstrate the gem's capabilities.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

Built with:

- [Ve](https://github.com/kimtaro/ve) - Japanese morphological analyzer
- [Mojinizer](https://github.com/ikayzo/mojinizer) - Japanese character utilities

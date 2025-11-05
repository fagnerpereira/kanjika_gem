# Kanjika

A comprehensive Ruby gem for working with Japanese language, focusing on verb conjugation and language utilities.

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

- 🎌 Japanese verb conjugation (all forms)
- 📝 Support for all verb types: Godan (五段), Ichidan (一段), and Irregular verbs
- 🔄 Multiple conjugation forms: te-form, ta-form, masu-form, causative, passive, potential, volitional
- 🎯 Simple and intuitive API
- ⚡ Built on top of Ve and Mojinizer for accurate morphological analysis

## Usage

### Verb Conjugation

Kanjika provides individual conjugator classes for different verb forms:

#### Masu Form (Polite Present)

```ruby
require 'kanjika'

# Positive form
conjugator = Kanjika::Conjugator::Masu.new("食べる")
conjugator.conjugate
# => "食べます"

# Negative form
conjugator.conjugate(negative: true)
# => "食べません"

# Works with all verb types
Kanjika::Conjugator::Masu.new("書く").conjugate    # => "書きます" (godan)
Kanjika::Conjugator::Masu.new("見る").conjugate    # => "見ます" (ichidan)
Kanjika::Conjugator::Masu.new("する").conjugate    # => "します" (irregular)
```

#### Te Form (Conjunctive)

```ruby
# Positive form
conjugator = Kanjika::Conjugator::Te.new("食べる")
conjugator.conjugate
# => "食べて"

# Negative form
conjugator.conjugate(negative: true)
# => "食べなくて"

# Godan verb examples
Kanjika::Conjugator::Te.new("書く").conjugate     # => "書いて"
Kanjika::Conjugator::Te.new("飲む").conjugate     # => "飲んで"
Kanjika::Conjugator::Te.new("買う").conjugate     # => "買って"
```

#### Ta Form (Past Tense)

```ruby
# Positive form
conjugator = Kanjika::Conjugator::Ta.new("食べる")
conjugator.conjugate
# => "食べた"

# Negative form
conjugator.conjugate(negative: true)
# => "食べなかった"

# Examples
Kanjika::Conjugator::Ta.new("行く").conjugate              # => "行った"
Kanjika::Conjugator::Ta.new("来る").conjugate              # => "来た"
Kanjika::Conjugator::Ta.new("する").conjugate              # => "した"
```

#### Causative Form (Make/Let someone do)

```ruby
conjugator = Kanjika::Conjugator::Causative.new("食べる")
conjugator.conjugate
# => "食べさせる"

# Examples
Kanjika::Conjugator::Causative.new("書く").conjugate    # => "書かせる"
Kanjika::Conjugator::Causative.new("飲む").conjugate    # => "飲ませる"
Kanjika::Conjugator::Causative.new("する").conjugate    # => "させる"
```

#### Passive Form (Be done to)

```ruby
conjugator = Kanjika::Conjugator::Passive.new("食べる")
conjugator.conjugate
# => "食べられる"

# Examples
Kanjika::Conjugator::Passive.new("書く").conjugate     # => "書かれる"
Kanjika::Conjugator::Passive.new("見る").conjugate     # => "見られる"
Kanjika::Conjugator::Passive.new("する").conjugate     # => "される"
```

#### Potential Form (Can do)

```ruby
conjugator = Kanjika::Conjugator::Potential.new("食べる")
conjugator.conjugate
# => "食べられる"

# Examples
Kanjika::Conjugator::Potential.new("書く").conjugate   # => "書ける"
Kanjika::Conjugator::Potential.new("飲む").conjugate   # => "飲める"
Kanjika::Conjugator::Potential.new("する").conjugate   # => "できる"
```

#### Volitional Form (Let's do/Will do)

```ruby
conjugator = Kanjika::Conjugator::Volitional.new("食べる")
conjugator.conjugate
# => "食べよう"

# Examples
Kanjika::Conjugator::Volitional.new("書く").conjugate  # => "書こう"
Kanjika::Conjugator::Volitional.new("行く").conjugate  # => "行こう"
Kanjika::Conjugator::Volitional.new("する").conjugate  # => "しよう"
```

### Base Conjugator Methods

The base conjugator provides useful methods for analyzing verbs:

```ruby
conjugator = Kanjika::Conjugator::Base.new("食べる")

# Get verb group
conjugator.group
# => :ichidan

# Get verb stem
conjugator.stem
# => "食べ"

# Get present tense forms (all variations)
conjugator.present
# => {
#   positive: { plain: "食べる", polite: "食べます" },
#   negative: { plain: "食べない", polite: "食べません" }
# }

# Check verb type
conjugator.ichidan?  # => true
conjugator.godan?    # => false
conjugator.suru?     # => false
```

### Verb Types Explained

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

## Conjugation Rules

### Godan Verbs
The last character changes based on the conjugation:
- う → わ/い/っ (depending on form)
- く → か/い/こ
- す → さ/し/そ
- etc.

### Ichidan Verbs
Remove る and add the appropriate ending:
- 食べる → 食べ + ます = 食べます
- 食べる → 食べ + て = 食べて

### Irregular Verbs
Memorized forms with special rules.

## Examples

### Common Verbs Conjugated

```ruby
# 食べる (taberu - to eat) - Ichidan
verb = "食べる"
Kanjika::Conjugator::Masu.new(verb).conjugate       # => "食べます"
Kanjika::Conjugator::Te.new(verb).conjugate         # => "食べて"
Kanjika::Conjugator::Ta.new(verb).conjugate         # => "食べた"
Kanjika::Conjugator::Causative.new(verb).conjugate  # => "食べさせる"
Kanjika::Conjugator::Passive.new(verb).conjugate    # => "食べられる"

# 書く (kaku - to write) - Godan
verb = "書く"
Kanjika::Conjugator::Masu.new(verb).conjugate       # => "書きます"
Kanjika::Conjugator::Te.new(verb).conjugate         # => "書いて"
Kanjika::Conjugator::Ta.new(verb).conjugate         # => "書いた"
Kanjika::Conjugator::Causative.new(verb).conjugate  # => "書かせる"

# する (suru - to do) - Irregular
verb = "する"
Kanjika::Conjugator::Masu.new(verb).conjugate       # => "します"
Kanjika::Conjugator::Te.new(verb).conjugate         # => "して"
Kanjika::Conjugator::Ta.new(verb).conjugate         # => "した"
Kanjika::Conjugator::Causative.new(verb).conjugate  # => "させる"
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

## Roadmap

Future features planned:
- Unified Verb interface for easier usage
- Conditional forms (ば, たら)
- Imperative forms
- Progressive forms (ている)
- Adjective conjugation
- CLI tool
- Rails helpers
- More comprehensive documentation

---

Made with ❤️ for Japanese language learners and developers

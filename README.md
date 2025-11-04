# Kanjika

Kanjika is a Ruby gem that provides comprehensive tools for working with the Japanese language, with a primary focus on verb conjugation. It accurately handles all three verb types (ichidan, godan, and irregular) and supports multiple conjugation forms.

## Features

- **Multiple Conjugation Forms**: Supports masu (polite), te-form, ta (past), causative, passive, potential, and volitional forms
- **All Verb Types**: Handles ichidan (ru-verbs), godan (u-verbs), and irregular verbs (する and 来る)
- **Compound Verbs**: Processes compound verbs like 勉強する (to study)
- **Negative Forms**: All conjugations support negative forms
- **Dual API**: Choose between factory method or fluent API syntax
- **High Test Coverage**: 96%+ code coverage with comprehensive test suite

## Quick Start

```ruby
require 'kanjika'

# Factory method
Kanjika.conjugate("食べる", :masu)  #=> "食べます"
Kanjika.conjugate("書く", :te)      #=> "書いて"

# Fluent API
verb = Kanjika.verb("話す")
verb.to(:masu)                      #=> "話します"
verb.to(:masu, negative: true)     #=> "話しません"
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kanjika'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install kanjika

## Usage

Kanjika provides a simple and intuitive API for conjugating Japanese verbs.

### Factory Method

You can use the `Kanjika.conjugate` method to conjugate a verb to a specific form:

```ruby
require 'kanjika'

Kanjika.conjugate("食べる", :masu) #=> "食べます"
Kanjika.conjugate("書く", :te)   #=> "書いて"
```

You can also conjugate to the negative form:

```ruby
Kanjika.conjugate("食べる", :masu, negative: true) #=> "食べません"
```

### Fluent API

For a more expressive and readable syntax, you can use the fluent API:

```ruby
require 'kanjika'

verb = Kanjika.verb("話す") # to speak

verb.to(:masu) #=> "話します"
verb.to(:masu, negative: true) #=> "話しません"
verb.to(:volitional) #=> "話そう"
```

### Supported Forms

Kanjika supports the following conjugation forms:

*   `:masu` (polite form)
*   `:te` (te-form)
*   `:ta` (past tense)
*   `:causative`
*   `:passive`
*   `:potential`
*   `:volitional`

## Japanese Verb Types

Kanjika understands the different types of Japanese verbs and applies the correct conjugation rules.

### Ichidan Verbs (一段動詞) - "Ru-verbs"

Verbs ending in る (ru) where the preceding character has an 'e' or 'i' sound.

*   Examples: 食べる (taberu - to eat), 見る (miru - to see), 起きる (okiru - to wake up)

### Godan Verbs (五段動詞) - "U-verbs"

Verbs ending in う (u), く (ku), ぐ (gu), す (su), つ (tsu), ぬ (nu), ぶ (bu), む (mu), or る (ru) (with an 'a', 'o', or 'u' sound before the る).

*   Examples: 買う (kau - to buy), 書く (kaku - to write), 話す (hanasu - to speak)

### Irregular Verbs (不規則動詞)

There are two main irregular verbs in Japanese:

*   する (suru - to do)
*   来る (kuru - to come)

Kanjika also handles compound verbs that use する, such as 勉強する (benkyou-suru - to study).

## Examples

You can find working examples in the `examples/` directory. To run the examples:

```bash
ruby examples/conjugate.rb
```

This will demonstrate both the factory method and fluent API approaches to verb conjugation.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Project Status

Kanjika is actively maintained with a comprehensive test suite of 203 examples, all passing. The gem currently supports:

- ✅ Seven conjugation forms (masu, te, ta, causative, passive, potential, volitional)
- ✅ All Japanese verb types (ichidan, godan, irregular)
- ✅ Negative conjugations
- ✅ Compound verbs (e.g., 勉強する)
- ✅ Both kanji and hiragana inputs
- ✅ Factory and fluent API patterns
- ✅ GitHub Actions CI pipeline
- ✅ 96%+ code coverage

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fagnerpereira/kanjika_gem.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


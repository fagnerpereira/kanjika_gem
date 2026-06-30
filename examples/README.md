# Kanjika Examples

This directory contains example scripts demonstrating how to use the Kanjika gem for Japanese verb conjugation.

## Running the Examples

All examples can be run directly from the command line. Make sure you've installed the gem dependencies first:

```bash
bundle install
```

### Available Examples

#### 1. Basic Usage (`basic_usage.rb`)

Demonstrates the fundamental features of Kanjika with common use cases:

```bash
ruby examples/basic_usage.rb
```

This example covers:
- Masu form (polite present/future)
- Te form (connective)
- Potential form (ability)
- Using the Verb object with fluent API

**Expected Output:**
```
============================================================
Kanjika - Japanese Verb Conjugation Examples
============================================================

1. MASU FORM (Polite Present/Future)
------------------------------------------------------------
食べる (taberu (to eat) - ichidan)
  Positive: 食べます
  Negative: 食べません
...
```

#### 2. All Conjugation Forms (`all_forms.rb`)

Shows all available conjugation forms for different verb types:

```bash
ruby examples/all_forms.rb
```

This example demonstrates:
- All conjugation forms (masu, te, potential, etc.)
- How different verb types (ichidan, godan, irregular) conjugate
- Both positive and negative forms

**Expected Output:**
```
╔====================================================================╗
║            KANJIKA - ALL CONJUGATION FORMS                        ║
╚====================================================================╝

======================================================================
VERB: 食べる (taberu - to eat (ichidan verb))
======================================================================

MASU FORM:
  Positive: 食べます
  Negative: 食べません
...
```

#### 3. Simple Conjugation (`conjugate.rb`)

A quick demonstration of the two main APIs:

```bash
ruby examples/conjugate.rb
```

This shows:
- Module-level `Kanjika.conjugate` method
- Fluent API with `Kanjika.verb`

## Interactive Console

For experimenting with the gem interactively, use the console:

```bash
bin/console
```

This will open an IRB session with Kanjika already loaded. You can try things like:

```ruby
# Try different conjugations
Kanjika.conjugate("食べる", :masu)
# => "食べます"

# Create a verb object
verb = Kanjika.verb("書く")
verb.to(:te)
# => "書いて"

# Experiment with negative forms
Kanjika.conjugate("飲む", :masu, negative: true)
# => "飲みません"
```

## Example Verb Types

### Ichidan Verbs (一段動詞)
- 食べる (taberu) - to eat
- 見る (miru) - to see
- 起きる (okiru) - to wake up

### Godan Verbs (五段動詞)
- 書く (kaku) - to write
- 飲む (nomu) - to drink
- 買う (kau) - to buy
- 話す (hanasu) - to speak
- 読む (yomu) - to read

### Irregular Verbs
- する (suru) - to do
- 来る (kuru) - to come

## Creating Your Own Examples

Feel free to create your own example scripts! The basic structure is:

```ruby
#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../lib/kanjika"

# Your code here
verb = Kanjika.verb("走る") # hashiru - to run
puts verb.to(:masu)  # => "走ります"
```

Make your script executable:

```bash
chmod +x examples/my_example.rb
ruby examples/my_example.rb
```

## Common Use Cases

### Checking if a verb can be conjugated

```ruby
verb = Kanjika.verb("食べる")
begin
  result = verb.to(:masu)
  puts "✓ Can conjugate: #{result}"
rescue => e
  puts "✗ Cannot conjugate: #{e.message}"
end
```

### Batch conjugation

```ruby
verbs = ["食べる", "書く", "する"]
verbs.each do |v|
  masu_form = Kanjika.conjugate(v, :masu)
  puts "#{v} -> #{masu_form}"
end
```

### Error handling

```ruby
begin
  Kanjika.conjugate("食べる", :unknown_form)
rescue => e
  puts "Error: #{e.message}"
end
```

## Need Help?

- Check the [main README](../README.md) for detailed documentation
- Visit the [GitHub repository](https://github.com/fagnerpereira/kanjika_gem)
- Open an issue if you find a bug or have a question

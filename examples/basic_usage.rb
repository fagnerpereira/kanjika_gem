#!/usr/bin/env ruby
# frozen_string_literal: true

# Basic usage examples for Kanjika gem

require_relative "../lib/kanjika"

puts "=" * 60
puts "Kanjika - Japanese Verb Conjugation Examples"
puts "=" * 60
puts

# Example 1: Masu Form (Polite Present/Future)
puts "1. MASU FORM (Polite Present/Future)"
puts "-" * 60

verbs = {
  "食べる" => "taberu (to eat) - ichidan",
  "書く" => "kaku (to write) - godan",
  "する" => "suru (to do) - irregular"
}

verbs.each do |verb, description|
  positive = Kanjika.conjugate(verb, :masu)
  negative = Kanjika.conjugate(verb, :masu, negative: true)
  puts "#{verb} (#{description})"
  puts "  Positive: #{positive}"
  puts "  Negative: #{negative}"
  puts
end

# Example 2: Te Form (Connective)
puts "2. TE FORM (Connective - 'and')"
puts "-" * 60

te_verbs = {
  "食べる" => "taberu (to eat)",
  "飲む" => "nomu (to drink)",
  "買う" => "kau (to buy)",
  "話す" => "hanasu (to speak)",
  "行く" => "iku (to go) - special case"
}

te_verbs.each do |verb, description|
  result = Kanjika.conjugate(verb, :te)
  puts "#{verb} (#{description}) -> #{result}"
end
puts

# Example 3: Potential Form (Can do)
puts "3. POTENTIAL FORM (Can do / Ability)"
puts "-" * 60

potential_verbs = {
  "食べる" => "taberu (to eat)",
  "書く" => "kaku (to write)",
  "読む" => "yomu (to read)",
  "する" => "suru (to do)"
}

potential_verbs.each do |verb, description|
  result = Kanjika.conjugate(verb, :potential)
  puts "#{verb} (#{description}) -> #{result}"
end
puts

# Example 4: Using the Verb object (fluent API)
puts "4. USING VERB OBJECT (Fluent API)"
puts "-" * 60

verb = Kanjika.verb("見る") # miru - to see
puts "Verb: 見る (miru - to see)"
puts "  Masu form: #{verb.to(:masu)}"
puts "  Te form: #{verb.to(:te)}"
puts "  Potential form: #{verb.to(:potential)}"
puts

puts "=" * 60
puts "Examples completed!"
puts "=" * 60

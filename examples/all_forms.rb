#!/usr/bin/env ruby
# frozen_string_literal: true

# Demonstrate all conjugation forms available in Kanjika

require_relative "../lib/kanjika"

def demonstrate_verb(verb_str, description)
  puts "\n" + "=" * 70
  puts "VERB: #{verb_str} (#{description})"
  puts "=" * 70

  verb = Kanjika.verb(verb_str)

  forms = [:masu, :te, :potential]

  forms.each do |form|
    begin
      positive = verb.to(form)
      negative = verb.to(form, negative: true)

      puts "\n#{form.to_s.upcase} FORM:"
      puts "  Positive: #{positive}"
      puts "  Negative: #{negative}"
    rescue => e
      puts "\n#{form.to_s.upcase} FORM:"
      puts "  Error: #{e.message}"
    end
  end
end

puts "╔" + "=" * 68 + "╗"
puts "║" + " " * 12 + "KANJIKA - ALL CONJUGATION FORMS" + " " * 24 + "║"
puts "╚" + "=" * 68 + "╝"

# Demonstrate with different verb types
demonstrate_verb("食べる", "taberu - to eat (ichidan verb)")
demonstrate_verb("書く", "kaku - to write (godan verb)")
demonstrate_verb("飲む", "nomu - to drink (godan verb)")
demonstrate_verb("する", "suru - to do (irregular verb)")
demonstrate_verb("来る", "kuru - to come (irregular verb)")

puts "\n" + "=" * 70
puts "All forms demonstrated!"
puts "=" * 70

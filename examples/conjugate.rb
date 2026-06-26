# examples/conjugate.rb

require_relative "../lib/kanjika"

puts "--- Using Kanjika.conjugate ---"
puts "'食べる' (to eat) -> masu form: #{Kanjika.conjugate("食べる", :masu)}"
puts "'書く' (to write) -> te form: #{Kanjika.conjugate("書く", :te)}"
puts "'飲む' (to drink) -> ta form: #{Kanjika.conjugate("飲む", :ta)}"
puts "'する' (to do) -> potential form: #{Kanjika.conjugate("する", :potential)}"
puts

puts "--- Using the fluent API ---"
verb = Kanjika.verb("話す") # to speak
puts "'話す' (to speak) -> masu form: #{verb.to(:masu)}"
puts "'話す' (to speak) -> masu form (negative): #{verb.to(:masu, negative: true)}"
puts "'話す' (to speak) -> volitional form: #{verb.to(:volitional)}"

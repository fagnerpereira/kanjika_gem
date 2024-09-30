require_relative "kanjika/version"

module Kanjika
  class Error < StandardError; end

  class Foobar
    def self.foobar
      puts 'foobar'
      'foo'
      end
end
end

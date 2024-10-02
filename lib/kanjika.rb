require_relative "kanjika/version"
require_relative "kanjika/conjugator/base"
require_relative "kanjika/conjugator/masu"
require_relative "kanjika/conjugator/te"
require "ve"
require "mojinizer"

module Kanjika
  class Error < StandardError; end
end

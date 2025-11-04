require_relative "kanjika/version"
require_relative "kanjika/conjugator/base"
require_relative "kanjika/conjugator/masu"
require_relative "kanjika/conjugator/te"
require_relative "kanjika/conjugator/ta"
require_relative "kanjika/conjugator/causative"
require_relative "kanjika/conjugator/passive"
require_relative "kanjika/conjugator/potential"
require_relative "kanjika/conjugator/volitional"
require "ve"
require "mojinizer"

module Kanjika
  class Error < StandardError; end
end

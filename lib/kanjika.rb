# frozen_string_literal: true

require "active_support/core_ext/string/inflections"
require "ve"
require "mojinizer"
require_relative "kanjika/version"
require_relative "kanjika/verb"
require_relative "kanjika/conjugator/base"
require_relative "kanjika/conjugator/masu"
require_relative "kanjika/conjugator/te"
require_relative "kanjika/conjugator/potential"


module Kanjika
  class Error < StandardError; end

  def self.verb(verb)
    Verb.new(verb)
  end

  def self.conjugate(verb, type, negative: false)
    Verb.new(verb).conjugate(type, negative: negative)
  end
end

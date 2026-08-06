# frozen_string_literal: true

require "active_support/core_ext/string/inflections"
require "ve"
require_relative "kanjika/ve_patch"
require "mojinizer"
require_relative "kanjika/version"
require_relative "kanjika/errors"
require_relative "kanjika/verb"
require_relative "kanjika/conjugator/base"
require_relative "kanjika/conjugator/masu"
require_relative "kanjika/conjugator/te"
require_relative "kanjika/conjugator/potential"

module Kanjika
  def self.verb(verb)
    Verb.new(verb)
  end

  def self.conjugate(verb, form, negative: false)
    Verb.new(verb).conjugate(form, negative: negative)
  end
end

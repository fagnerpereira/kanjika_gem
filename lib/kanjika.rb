require_relative "kanjika/version"
require_relative "kanjika/errors"
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
  CONJUGATORS = {
    masu: Conjugator::Masu,
    te: Conjugator::Te,
    ta: Conjugator::Ta,
    causative: Conjugator::Causative,
    passive: Conjugator::Passive,
    potential: Conjugator::Potential,
    volitional: Conjugator::Volitional
  }.freeze

  def self.conjugate(verb, form, negative: false)
    conjugator = CONJUGATORS[form]
    raise "Unknown form #{form}" unless conjugator
    conjugator.new(verb).conjugate(negative: negative)
  end

  def self.verb(verb)
    Verb.new(verb)
  end

  class Verb
    def initialize(verb)
      @verb = verb
    end

    def to(form, negative: false)
      Kanjika.conjugate(@verb, form, negative: negative)
    end
  end
end

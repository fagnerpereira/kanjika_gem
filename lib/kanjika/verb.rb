# frozen_string_literal: true

module Kanjika
  class Verb
    attr_reader :verb

    def initialize(verb)
      @verb = verb
    end

    def conjugate(type, negative: false)
      conjugator_class = conjugators[type&.to_sym]
      raise "Unknown form #{type}" unless conjugator_class

      conjugator_class.new(verb).conjugate(negative: negative)
    end

    alias_method :to, :conjugate

    private

    def conjugators
      {
        masu: Kanjika::Conjugator::Masu,
        te: Kanjika::Conjugator::Te,
        potential: Kanjika::Conjugator::Potential
      }
    end
  end
end

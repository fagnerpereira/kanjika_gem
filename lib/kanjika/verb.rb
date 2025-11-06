# frozen_string_literal: true

module Kanjika
  class Verb
    attr_reader :verb

    def initialize(verb)
      @verb = verb
    end

    def conjugate(type, negative: false)
      "Kanjika::Conjugator::#{type.to_s.camelize}".constantize.new(verb).conjugate(negative: negative)
    end
  end
end

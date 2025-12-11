# frozen_string_literal: true

module Kanjika
  class Verb
    attr_reader :verb

    def initialize(verb)
      @verb = verb
    end

    def conjugate(type, negative: false)
      conjugator_class = "Kanjika::Conjugator::#{type.to_s.camelize}"
      conjugator_class.constantize.new(verb).conjugate(negative: negative)
    rescue NameError
      raise "Unknown form #{type}"
    end

    alias_method :to, :conjugate
  end
end

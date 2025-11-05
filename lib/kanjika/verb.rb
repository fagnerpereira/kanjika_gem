module Kanjika
  class Verb
    attr_reader :verb_string

    def initialize(verb_string)
      @verb_string = verb_string
    end

    # Convenience methods for all conjugation forms

    def masu(negative: false)
      Conjugator::Masu.new(verb_string).conjugate(negative: negative)
    end

    def te(negative: false)
      Conjugator::Te.new(verb_string).conjugate(negative: negative)
    end

    def ta(negative: false)
      Conjugator::Ta.new(verb_string).conjugate(negative: negative)
    end

    def causative
      Conjugator::Causative.new(verb_string).conjugate
    end

    def passive
      Conjugator::Passive.new(verb_string).conjugate
    end

    def potential
      Conjugator::Potential.new(verb_string).conjugate
    end

    def volitional
      Conjugator::Volitional.new(verb_string).conjugate
    end

    # Aliases for easier access
    alias polite masu
    alias past ta
    alias make_do causative
    alias can_do potential
    alias lets_do volitional

    # Get all conjugation forms at once
    def all_forms
      {
        dictionary: verb_string,
        masu: {
          positive: masu,
          negative: masu(negative: true)
        },
        te: {
          positive: te,
          negative: te(negative: true)
        },
        ta: {
          positive: ta,
          negative: ta(negative: true)
        },
        causative: causative,
        passive: passive,
        potential: potential,
        volitional: volitional,
        present: present
      }
    end

    # Delegate analysis methods to Base conjugator
    def group
      base_conjugator.group
    end

    def stem
      base_conjugator.stem
    end

    def present
      base_conjugator.present
    end

    def ichidan?
      base_conjugator.ichidan?
    end

    def godan?
      base_conjugator.godan?
    end

    def suru?
      base_conjugator.suru?
    end

    def irregular?
      base_conjugator.irregular?
    end

    # String representation
    def to_s
      verb_string
    end

    def inspect
      "#<Kanjika::Verb #{verb_string} (#{group})>"
    end

    private

    def base_conjugator
      @base_conjugator ||= Conjugator::Base.new(verb_string)
    end
  end
end

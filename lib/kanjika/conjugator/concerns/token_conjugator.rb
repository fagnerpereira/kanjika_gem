module Kanjika
  module Conjugator
    module Concerns
      module TokenConjugator
        def conjugate
          process.flat_map do |word|
            word.tokens.map { |token| conjugate_token(word, token) }.join
          end.join
        end

        private

        def conjugate_token(word, token)
          if word.part_of_speech.name == "verb"
            conjugate_verb(token)
          else
            conjugate_others(token)
          end
        end

        def conjugate_verb(token)
          verb_type = determine_verb_type(token)
          apply_conjugation_rule(verb_type)
        end

        def apply_conjugation_rule(verb_type)
          case verb_type
          when Base::ICHIDAN_TYPE
            conjugate_ichidan
          when Base::GODAN_TYPE
            conjugate_godan
          when Base::IRREGULAR_TYPE
            conjugate_irregular
          else
            raise ArgumentError, "Unknown or nil verb_type: #{verb_type.inspect}"
          end
        end

        # These methods should be implemented by the including class
        def conjugate_ichidan
          raise NotImplementedError, "#{self.class} must implement #conjugate_ichidan"
        end

        def conjugate_godan
          raise NotImplementedError, "#{self.class} must implement #conjugate_godan"
        end

        def conjugate_irregular
          raise NotImplementedError, "#{self.class} must implement #conjugate_irregular"
        end

        def conjugate_others(token)
          raise NotImplementedError, "#{self.class} must implement #conjugate_others"
        end
      end
    end
  end
end

module Kanjika
  module Conjugator
    class Te < Base
      GODAN_ENDINGS = {
        :う => {
          positive: "って",
          negative: "わなくて"
        },
        :く => {
          positive: "いて",
          negative: "かなくて"
        },
        :ぐ => {
          positive: "いで",
          negative: "がなくて"
        },
        :す => {
          positive: "して",
          negative: "さなくて"
        },
        :つ => {
          positive: "って",
          negative: "たなくて"
        },
        :ぬ => {
          positive: "んで",
          negative: "ななくて"
        },
        :ぶ => {
          positive: "んで",
          negative: "ばなくて"
        },
        :む => {
          positive: "んで",
          negative: "まなくて"
        },
        :る => {
          positive: "って",
          negative: "らなくて"
        }
      }
      IRREGULARS = {
        "する" => "して"
      }

      def conjugate(negative: false)
        @negative = negative

        Ve.in(:ja).words(verb).flat_map do |word|
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

      def determine_verb_type(token)
        return :ichidan if ichidan?(token)
        return :godan if godan?(token)
        :irregular if irregular?(token)
      end

      CONJUGATION_RULES = {
        ichidan: ->(stem, last_char) { stem + ICHIDAN_ENDINGS[last_char] },
        godan: ->(stem, last_char) { stem + GODAN_ENDINGS[last_char] },
        irregular: ->(verb) { IRREGULARS[verb] }
      }

      def apply_conjugation_rule(verb_type)
        case verb_type
        when ICHIDAN_TYPE
          conjugate_ichidan
        when GODAN_TYPE
          conjugate_godan
        when IRREGULAR_TYPE
          # IRREGULARS[lemma] + suffix
        end
        # rule = CONJUGATION_RULES[verb_type]
        # case verb_type
        # when :ichidan
        #   rule.call(stem, verb[-1])
        # when :godan
        #   rule.call(stem, verb[-1])
        # when :irregular
        #   rule.call(verb)
        # end
      end

      def conjugate_godan
        # Transform u->i for godan stem
        godan_stem = verb[0..-2] + verb[-1].tr(U_ENDINGS, I_ENDINGS)
        godan_stem + suffix
      end

      def suffix
        if @negative
          GODAN_ENDINGS.dig(verb[-1].to_sym, :negative)
        else
          GODAN_ENDINGS.dig(verb[-1].to_sym, :positive)
        end
      end

      def conjugate_ichidan
        # Remove る and add て/なくて for ichidan verbs
        if @negative
          verb.chop + "なくて"
        else
          verb.chop + "て"
        end
      end

      def conjugate_others(token)
        if token[:raw].include?(NOUN_VERB)
          verb + IRREGULARS["する"]
        else
          "invalid verb"
        end
      end

      def ichidan?(token)
        token[:inflection_type].split("・").include?(ICHIDAN)
      end

      def godan?(token)
        token[:inflection_type].split("・").include?(GODAN)
      end

      def irregular?(token)
        token[:inflection_type].split("・").include?(KURU) ||
          token[:inflection_type].split("・").include?(SURU)
      end
    end
  end
end

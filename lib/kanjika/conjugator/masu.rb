module Kanjika
  module Conjugator
    class Masu < Base
      GODAN_ENDINGS = {
        "う" => "い",
        "く" => "き",
        "ぐ" => "ぎ",
        "す" => "し",
        "つ" => "ち",
        "ぬ" => "に",
        "ぶ" => "び",
        "む" => "み",
        "る" => "り"
      }
      ICHIDAN_MASU_FORMS = {
        "る" => "ます"
      }
      IRREGULARS = {
        "来る" => "来ます",
        "くる" => "きます",
        "する" => "します"
      }

      CONJUGATION_RULES = {
        ichidan: ->(stem) { stem + "ます" },
        godan: ->(stem, last_char) { stem + GODAN_ENDINGS[last_char] + "ます" },
        irregular: ->(verb) { IRREGULARS[verb] }
      }

      def conjugate
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

      def apply_conjugation_rule(verb_type)
        rule = CONJUGATION_RULES[verb_type]
        case verb_type
        when :ichidan
          rule.call(stem)
        when :godan
          rule.call(stem, verb[-1])
        when :irregular
          rule.call(verb)
        end
      end

      def conjugate_others(token)
        return verb + "します" if verb.kanji?

        if ending_in_e_or_i?
          CONJUGATION_RULES[:ichidan].call(stem)
        elsif godan_ending?
          CONJUGATION_RULES[:godan].call(stem, verb[-1])
        end
      end

      def ichidan?(token)
        token[:inflection_type].match?(ICHIDAN)
      end

      def godan?(token)
        token[:inflection_type].match?(GODAN)
      end

      def irregular?(token)
        token[:inflection_type].match?(SURU) || token[:inflection_type].match?(KURU)
      end

      def ending_in_e_or_i?
        E_ENDINGS.include?(verb[-2]) || I_ENDINGS.include?(verb[-2])
      end

      def godan_ending?
        GODAN_ENDINGS.key?(verb[-1])
      end

      def stem
        verb.chop
      end
    end
  end
end

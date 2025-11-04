module Kanjika
  module Conjugator
    class Passive < Base
      SUFFIX = "れる"

      # Map u-sound endings to a-sound endings
      GODAN_TRANSFORM = {
        "う" => "わ",
        "く" => "か",
        "ぐ" => "が",
        "す" => "さ",
        "ず" => "ざ",
        "つ" => "た",
        "づ" => "だ",
        "ぬ" => "な",
        "ふ" => "は",
        "ぶ" => "ば",
        "む" => "ま",
        "る" => "ら"
      }

      IRREGULARS = {
        "する" => "される",
        "来る" => "来られる",
        "くる" => "こられる"
      }

      def conjugate(negative: false)
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
        case verb_type
        when ICHIDAN_TYPE
          conjugate_ichidan
        when GODAN_TYPE
          conjugate_godan
        when IRREGULAR_TYPE
          conjugate_irregular
        end
      end

      def conjugate_godan
        # Transform last character (u-ending) to a-ending, then add れる
        verb[0..-2] + GODAN_TRANSFORM[verb[-1]] + SUFFIX
      end

      def conjugate_ichidan
        # Remove る and add られる
        verb.chop + "ら" + SUFFIX
      end

      def conjugate_irregular
        IRREGULARS[verb]
      end

      def conjugate_others(token)
        if token[:raw].include?(NOUN_VERB)
          verb + "される"
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

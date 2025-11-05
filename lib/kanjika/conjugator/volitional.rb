module Kanjika
  module Conjugator
    class Volitional < Base
      include Concerns::VerbTypeDetector
      include Concerns::TokenConjugator

      SUFFIX = "う"

      # Map u-sound endings to o-sound endings
      GODAN_TRANSFORM = {
        "う" => "お",
        "く" => "こ",
        "ぐ" => "ご",
        "す" => "そ",
        "ず" => "ぞ",
        "つ" => "と",
        "づ" => "ど",
        "ぬ" => "の",
        "ふ" => "ほ",
        "ぶ" => "ぼ",
        "む" => "も",
        "る" => "ろ"
      }

      IRREGULARS = {
        "する" => "しよう",
        "来る" => "来よう",
        "くる" => "こよう"
      }

      private

      def conjugate_godan
        # Transform last character (u-ending) to o-ending, then add う
        verb[0..-2] + GODAN_TRANSFORM[verb[-1]] + SUFFIX
      end

      def conjugate_ichidan
        # Remove る and add よう
        verb.chop + "よう"
      end

      def conjugate_irregular
        IRREGULARS[verb] || raise(InvalidVerbError, "Unknown irregular verb: #{verb}")
      end

      def conjugate_others(token)
        if token[:raw].include?(NOUN_VERB)
          verb + "しよう"
        else
          raise InvalidVerbError, "Cannot conjugate '#{verb}' to volitional form"
        end
      end
    end
  end
end

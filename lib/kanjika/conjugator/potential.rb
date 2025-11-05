module Kanjika
  module Conjugator
    class Potential < Base
      include Concerns::VerbTypeDetector
      include Concerns::TokenConjugator

      SUFFIX = "る"

      # Map u-sound endings to e-sound endings
      GODAN_TRANSFORM = {
        "う" => "え",
        "く" => "け",
        "ぐ" => "げ",
        "す" => "せ",
        "ず" => "ぜ",
        "つ" => "て",
        "づ" => "で",
        "ぬ" => "ね",
        "ふ" => "へ",
        "ぶ" => "べ",
        "む" => "め",
        "る" => "れ"
      }

      IRREGULARS = {
        "する" => "できる",
        "来る" => "来られる",
        "くる" => "こられる"
      }

      private

      def conjugate_godan
        # Transform last character (u-ending) to e-ending, then add る
        verb[0..-2] + GODAN_TRANSFORM[verb[-1]] + SUFFIX
      end

      def conjugate_ichidan
        # Remove る and add られる
        verb.chop + "られる"
      end

      def conjugate_irregular
        IRREGULARS[verb] || raise(InvalidVerbError, "Unknown irregular verb: #{verb}")
      end

      def conjugate_others(token)
        if token[:raw].include?(NOUN_VERB)
          verb + "できる"
        else
          raise InvalidVerbError, "Cannot conjugate '#{verb}' to potential form"
        end
      end
    end
  end
end

module Kanjika
  module Conjugator
    class Passive < Base
      include Concerns::VerbTypeDetector
      include Concerns::TokenConjugator

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

      private

      def conjugate_godan
        # Transform last character (u-ending) to a-ending, then add れる
        verb[0..-2] + GODAN_TRANSFORM[verb[-1]] + SUFFIX
      end

      def conjugate_ichidan
        # Remove る and add られる
        verb.chop + "ら" + SUFFIX
      end

      def conjugate_irregular
        IRREGULARS[verb] || raise(InvalidVerbError, "Unknown irregular verb: #{verb}")
      end

      def conjugate_others(token)
        if token[:raw].include?(NOUN_VERB)
          verb + "される"
        else
          raise InvalidVerbError, "Cannot conjugate '#{verb}' to passive form"
        end
      end
    end
  end
end

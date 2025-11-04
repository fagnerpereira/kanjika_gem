module Kanjika
  module Conjugator
    class Ta < Base
      GODAN_ENDINGS = {
        :う => {
          positive: "った",
          negative: "わなかった"
        },
        :く => {
          positive: "いた",
          negative: "かなかった"
        },
        :ぐ => {
          positive: "いだ",
          negative: "がなかった"
        },
        :す => {
          positive: "した",
          negative: "さなかった"
        },
        :つ => {
          positive: "った",
          negative: "たなかった"
        },
        :ぬ => {
          positive: "んだ",
          negative: "ななかった"
        },
        :ぶ => {
          positive: "んだ",
          negative: "ばなかった"
        },
        :む => {
          positive: "んだ",
          negative: "まなかった"
        },
        :る => {
          positive: "った",
          negative: "らなかった"
        }
      }

      ICHIDAN_ENDINGS = {
        positive: "た",
        negative: "なかった"
      }

      IRREGULARS = {
        "する" => {
          positive: "した",
          negative: "しなかった"
        },
        "勉強する" => {
          positive: "勉強した",
          negative: "勉強しなかった"
        },
        "来る" => {
          positive: "来た",
          negative: "来なかった"
        },
        "くる" => {
          positive: "きた",
          negative: "こなかった"
        }
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
        # Special case for 行く (iku) - positive form conjugates like う-verb
        if verb == "行く" && !@negative
          return verb[0..-2] + GODAN_ENDINGS[:う][:positive]
        end

        # Replace last character with the appropriate ta-form ending
        verb[0..-2] + suffix
      end

      def suffix
        ending_char = verb[-1]
        if @negative
          GODAN_ENDINGS.dig(ending_char.to_sym, :negative)
        else
          GODAN_ENDINGS.dig(ending_char.to_sym, :positive)
        end
      end

      def conjugate_ichidan
        # Remove る directly
        verb.chop + (@negative ? ICHIDAN_ENDINGS[:negative] : ICHIDAN_ENDINGS[:positive])
      end

      def conjugate_irregular
        IRREGULARS.dig(verb, @negative ? :negative : :positive)
      end

      def conjugate_others(token)
        # Handle kanji compound verbs (like 勉強)
        if verb.kanji?
          return verb + IRREGULARS.dig("する", @negative ? :negative : :positive)
        end

        # Handle noun-verb pattern (サ変接続)
        if token[:raw].include?(NOUN_VERB)
          verb.gsub("する", "") + IRREGULARS.dig("する", @negative ? :negative : :positive)
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

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
      ICHIDAN_ENDINGS = {
        "る" => "て"
      }.freeze

      IRREGULARS = {
        "くる" => {positive: "きて", negative: "こなくて"},
        "来る" => {positive: "来て", negative: "来なくて"}
      }.freeze

      def conjugate_token(word, token)
        if word.part_of_speech.name == "verb"
          conjugate_verb(token)
        else
          conjugate_others(token)
        end
      end

      def conjugate_verb(token)
        verb_type = determine_verb_type(token)
        return token[:lemma] if verb_type.nil?
        apply_conjugation_rule(verb_type, token)
      end

      def determine_verb_type(token)
        return :ichidan if ichidan?(token)
        return :godan if godan?(token)
        :irregular if irregular?(token)
      end

      def apply_conjugation_rule(verb_type, token)
        lemma = token[:lemma]
        case verb_type
        when ICHIDAN_TYPE
          conjugate_ichidan
        when GODAN_TYPE
          conjugate_godan
        when IRREGULAR_TYPE
          if suru?(token)
            stem = lemma.gsub("する", "")
            return @negative ? stem + "しなくて" : stem + "して"
          end

          conjugation = IRREGULARS[lemma]
          if conjugation
            @negative ? conjugation[:negative] : conjugation[:positive]
          end
        end
      end

      def conjugate_godan
        if verb == "行く"
          return @negative ? "行かなくて" : "行って"
        end
        stem = verb[0..-2]
        stem + suffix
      end

      def suffix
        ending = verb[-1]
        if @negative
          GODAN_ENDINGS.dig(ending.to_sym, :negative)
        else
          GODAN_ENDINGS.dig(ending.to_sym, :positive)
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
          verb + (@negative ? "しなくて" : "して")
        else
          raise InvalidVerbError, "'#{verb}' is not a valid verb"
        end
      end
    end
  end
end

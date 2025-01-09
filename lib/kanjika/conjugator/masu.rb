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

      def conjugate(negative: false)
        @negative = negative

        Ve.in(:ja).words(verb).flat_map do |word|
          word.tokens.map { |token| conjugate_token(word, token) }.join
        end.join
      end

      private

      def conjugate_token(word, token)
        if ["adverb"].include?(word.part_of_speech.name)
          return token[:lemma]
        end

        conjugated = if word.part_of_speech.name == "verb"
          conjugate_verb(token)
        else
          conjugate_others(token)
        end
        return token[:lemma] if conjugated.nil?

        conjugated
      end

      def conjugate_verb(token)
        verb_type = determine_verb_type(token)
        return token[:lemma] if verb_type.nil?

        apply_conjugation_rule(verb_type, token[:lemma])
      end

      def determine_verb_type(token)
        return ICHIDAN_TYPE if ichidan?(token)
        return GODAN_TYPE if godan?(token)
        IRREGULAR_TYPE if irregular?(token)
      end

      def apply_conjugation_rule(verb_type, lemma)
        case verb_type
        when ICHIDAN_TYPE
          stem + suffix
        when GODAN_TYPE
          stem + GODAN_ENDINGS[verb[-1]] + suffix
        when IRREGULAR_TYPE
          IRREGULARS[lemma]
        end
      end

      def conjugate_others(token)
        return verb + "し#{suffix}" if verb.kanji?

        if ending_in_e_or_i?
          stem + suffix
        elsif godan_ending?
          stem + GODAN_ENDINGS[verb[-1]] + suffix
        end
      end

      def suffix
        return "ません" if @negative

        "ます"
      end
    end
  end
end

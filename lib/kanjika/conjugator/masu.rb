module Kanjika
  module Conjugator
    class Masu < Base
      IRREGULARS = {
        "する" => "し",
        "来る" => "来",
        "くる" => "き"
      }

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
      }.freeze

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
          conjugate_ichidan(lemma)
        when GODAN_TYPE
          conjugate_godan(lemma)
        when IRREGULAR_TYPE
          IRREGULARS[lemma] + suffix
        end
      end

      def conjugate_godan(lemma)
        # Transform u->i for godan verbs, then add suffix
        godan_stem = lemma[0..-2] + lemma[-1].tr(U_ENDINGS, I_ENDINGS)
        godan_stem + suffix
      end

      def conjugate_ichidan(lemma)
        # Remove る for ichidan verbs
        lemma.chop + suffix
      end

      def conjugate_others(token)
        return verb + "し#{suffix}" if verb.kanji?

        if ending_in_e_or_i?
          verb.chop + suffix
        elsif godan_ending?
          conjugate_godan(verb)
        end
      end

      def godan_ending?
        GODAN_ENDINGS.key?(verb[-1])
      end

      def suffix
        return "ません" if @negative

        "ます"
      end
    end
  end
end


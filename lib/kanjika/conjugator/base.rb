# frozen_string_literal: true

module Kanjika
  module Conjugator
    class Base
      U_ENDINGS = "うくぐすつぬふぶむる"
      A_ENDINGS = "わかがさたなはまら"
      E_ENDINGS = "えけげせてねへべめれ"
      I_ENDINGS = "いきぎしちにひびみり"

      # https://conjugator.reverso.net/conjugation-rules-model-japanese-info.html
      ICHIDAN_TYPE = :ichidan
      GODAN_TYPE = :godan
      IRREGULAR_TYPE = :irregular

      # Godan (ごだん)
      GODAN = "五段"
      # Ichidan (いちだん)
      ICHIDAN = "一段"
      # Suru (する)
      SURU = "サ変"
      # Kuru (くる)
      KURU = "カ変"
      # Noun verb (サ変接続)
      NOUN_VERB = "サ変接続"

      IRREGULARS_STEM = {
        # Kuru (くる) -> Ki (き)
        "来る" => "来",
        "くる" => "き"
      }

      attr_reader :verb

      def initialize(verb)
        @verb = verb
      end

      def group
        return :ichidan if ichidan?
        return :godan if godan?
        return :suru if suru?
        :irregular
      end

      def stem
        return if verb.to_s.empty?

        return verb.chop if ichidan?
        return verb.tr(U_ENDINGS, I_ENDINGS) if godan?
        return verb.gsub("する", "し") if suru?
        IRREGULARS_STEM[verb]
      end

      def present
        {
          positive: {
            plain: process.first.lemma,
            polite: "#{stem}ます"
          },
          negative: {
            plain: negative_plain_form,
            polite: "#{stem}ません"
          }
        }
      end

      def negative_plain_form
        if godan?
          # For godan verbs, transform u->a for negative
          verb.chop + verb[-1].tr(U_ENDINGS, A_ENDINGS) + "ない"
        else
          # For ichidan, suru, and irregular, use stem + ない
          "#{stem}ない"
        end
      end

      def conjugate
        raise NotImplementedError
      end

      def ichidan?
        inflection_types.include?(ICHIDAN)
      end

      def godan?
        inflection_types.include?(GODAN)
      end

      def suru?
        inflection_types.include?(SURU) || inflection_types.include?(NOUN_VERB)
      end

      def irregular?
        inflection_types.include?(KURU)
      end

      def ending_in_e_or_i?
        E_ENDINGS.include?(verb[-2]) || I_ENDINGS.include?(verb[-2])
      end

      def inflection_types
        process.flat_map do |word|
          word.tokens.map { |token| token[:inflection_type] }
        end.compact.flat_map { |type| type.split("・") }.uniq
      end

      def process
        return [] if verb.to_s.empty?
        @process ||= Ve.in(:ja).words(verb)
      end
    end
  end
end

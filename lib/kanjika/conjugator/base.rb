module Kanjika
  module Conjugator
    class Base
      U_ENDINGS = "うくぐすずつづぬふぶむる"
      A_ENDINGS = "わかがさざただなはばまら"
      E_ENDINGS = "えけげせぜてでねへべめれ"
      I_ENDINGS = "いきぎしじちぢにひびみり"
      O_ENDINGS = "おこごそぞとどのほぼもろ"

      # https://conjugator.reverso.net/conjugation-rules-model-japanese-info.html
      ICHIDAN_TYPE = :ichidan
      GODAN_TYPE = :godan
      IRREGULAR_TYPE = :irregular

      GODAN = "五段"
      ICHIDAN = "一段"
      SURU = "サ変"
      KURU = "カ変"
      NOUN_VERB = "サ変接続"

      IRREGULARS_STEM = {
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
        return verb.chop if ichidan?
        return verb.tr(U_ENDINGS, I_ENDINGS) if godan?
        return verb.gsub("する", "し") if suru?
        IRREGULARS_STEM[verb]
      end

      def present
        {
          positive: {
            plain: process.lemma,
            polite: stem + "ます"
          },
          negative: {
            plain: negative_plain_form,
            polite: stem + "ません"
          }
        }
      end

      def negative_plain_form
        if godan?
          # For godan verbs, transform u->a for negative
          verb[0..-2] + verb[-1].tr(U_ENDINGS, A_ENDINGS) + "ない"
        else
          # For ichidan, suru, and irregular, use stem + ない
          stem + "ない"
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
        inflection_types.include?(SURU)
      end

      def irregular?
        inflection_types.include?(KURU)
      end

      def ending_in_e_or_i?
        E_ENDINGS.include?(verb[-2]) || I_ENDINGS.include?(verb[-2])
      end

      def inflection_types
        @inflection_types ||= process.tokens.map do |tokens|
          tokens[:inflection_type].split("・")
        end.flatten
      end

      def process
        @process ||= Ve.in(:ja).words(verb).first
      end
    end
  end
end

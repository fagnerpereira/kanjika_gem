module Kanjika
  module Conjugator
    class Base
      U_ENDINGS = "うくぐすずつづぬふぶむる"
      E_ENDINGS = "えけげせぜてでねへべめれ"
      I_ENDINGS = "いきぎしじちぢにひびみり"

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
        # binding.irb
        return verb.chop if ichidan?
        return verb.tr(U_ENDINGS, I_ENDINGS) if godan?
        return verb.gsub("する", "し") if suru?
        IRREGULARS_STEM[verb]
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
        Ve.in(:ja).words(verb).first.tokens.map do |tokens|
          tokens[:inflection_type].split("・")
        end.flatten
      end
    end
  end
end

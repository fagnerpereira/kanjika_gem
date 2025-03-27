module Kanjika
  module Conjugator
    class Base
      U_ENDINGS = "うくぐすずつづぬふぶむゆる"
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

      def stem
        verb.chop
      end
    end
  end
end

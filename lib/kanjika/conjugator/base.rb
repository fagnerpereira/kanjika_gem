module Kanjika
  module Conjugator
    class Base
      U_ENDINGS = "うくぐすずつづぬふぶむゆる"
      E_ENDINGS = "えけげせぜてでねへべめれ"
      I_ENDINGS = "いきぎしじちぢにひびみり"

      ICHIDAN_TYPE = :ichidan
      GODAN_TYPE = :godan
      IRREGULAR_TYPE = :irregular

      GODAN = "五段"
      ICHIDAN = "一段"
      SURU = "カ変"
      KURU = "サ変"
      NOUN_VERB = "サ変接続"

      attr_reader :verb

      def initialize(verb)
        @verb = verb
      end

      def conjugate
        raise NotImplementedError
      end

      def ichidan?(token)
        token[:inflection_type].match?(ICHIDAN)
      end

      def godan?(token)
        token[:inflection_type].match?(GODAN)
      end

      def irregular?(token)
        token[:inflection_type].match?(SURU) || token[:inflection_type].match?(KURU)
      end

      def ending_in_e_or_i?
        E_ENDINGS.include?(verb[-2]) || I_ENDINGS.include?(verb[-2])
      end

      def godan_ending?
        GODAN_ENDINGS.key?(verb[-1])
      end

      def stem
        verb.chop
      end
    end
  end
end

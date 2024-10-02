module Kanjika
  module Conjugator
    class Base
      U_ENDINGS = "うくぐすずつづぬふぶむゆる"
      E_ENDINGS = "えけげせぜてでねへべめれ"
      I_ENDINGS = "いきぎしじちぢにひびみり"

      GODAN = "五段"
      ICHIDAN = "一段"
      SURU = "カ変"
      KURU = "サ変"
      NOUN_VERB = "サ変接続"

      def self.conjugate(verb)
        new(verb).conjugate
      end

      attr_reader :verb

      def initialize(verb)
        @verb = verb
      end

      def conjugate
        raise NotImplementedError
      end
    end
  end
end

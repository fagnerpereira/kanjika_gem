module Kanjika
  module Conjugator
    class Base
      U_ENDINGS = "うくぐすずつづぬふぶむゆる"
      E_ENDINGS = "えけげせぜてでねへべめれ"
      I_ENDINGS = "いきぎしじちぢにひびみり"
      # Ichidan verbs (る-verbs)
      ICHIDAN_MASU_FORMS = {
        "る" => "ます"  # e.g., 食べる → 食べます, 見る → 見ます
      }
      # Irregular verbs
      IRREGULAR_MASU_FORMS = {
        "来る" => "来ます",  # e.g., 来る → 来ます (to come)
        "くる" => "きます",  # e.g., くる → きます (to come)
        "する" => "します"  # e.g., する → します (to do)
      }
      GODAN = "五段"
      ICHIDAN = "一段"
      SURU = "カ変"
      KURU = "サ変"

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

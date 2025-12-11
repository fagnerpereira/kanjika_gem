# frozen_string_literal: true

module Kanjika
  module Conjugator
    class Masu < Base
      def conjugate(negative: false)
        "#{stem}#{suffix(negative)}"
      end

      private

      def suffix(negative)
        negative ? "ません" : "ます"
      end
    end
  end
end

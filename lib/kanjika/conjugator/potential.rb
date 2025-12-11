# frozen_string_literal: true

module Kanjika
  module Conjugator
    class Potential < Base
      def conjugate(negative: false)
        case group
        when :ichidan
          "#{stem}られる" # rareru
        when :godan
          godan_potential
        when :suru
          verb.end_with?("する") ? verb.sub(/する$/, "できる") : "できる" # dekiru
        when :irregular
          "来られる" # korareru
        end
      end

      private

      def godan_potential
        verb.tr(U_ENDINGS, E_ENDINGS) + "る" # ru
      end
    end
  end
end

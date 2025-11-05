# frozen_string_literal: true

module Kanjika
  module Conjugator
    class Potential < Base
      def conjugate(negative: false)
        case group
        when :ichidan
          "#{stem}られる"
        when :godan
          godan_potential
        when :suru
          'できる'
        when :irregular
          '来られる'
        end
      end

      private

      def godan_potential
        verb.tr(U_ENDINGS, E_ENDINGS) + 'る'
      end
    end
  end
end

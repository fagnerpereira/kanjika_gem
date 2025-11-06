# frozen_string_literal: true

module Kanjika
  module Conjugator
    class Te < Base
      GODAN_MAPPING = {
        'う' => 'って', 'つ' => 'って', 'る' => 'って',
        'む' => 'んで', 'ぶ' => 'んで', 'ぬ' => 'んで',
        'く' => 'いて',
        'ぐ' => 'いで',
        'す' => 'して'
      }.freeze

      def conjugate(negative: false)
        return negative_te_form if negative
        return '行って' if verb == '行く' || verb == 'いく'

        case group
        when :ichidan
          "#{stem}て"
        when :godan
          verb.chop + GODAN_MAPPING.fetch(verb[-1])
        when :suru
          "#{stem}て"
        when :irregular
          "#{stem}て"
        end
      end

      private

      def negative_te_form
        negative_plain_form.chop + 'くて'
      end
    end
  end
end

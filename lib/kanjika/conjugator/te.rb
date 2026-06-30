# frozen_string_literal: true

module Kanjika
  module Conjugator
    class Te < Base
      GODAN_MAPPING = {
        "う" => "って", # tte
        "つ" => "って", # tte
        "る" => "って", # tte
        "む" => "んで", # nde
        "ぶ" => "んで", # nde
        "ぬ" => "んで", # nde
        "く" => "いて", # ite
        "ぐ" => "いで", # ide
        "す" => "して"  # shite
      }.freeze

      def conjugate(negative: false)
        return negative_te_form if negative
        # Special case for 行く (iku) -> 行って (itte)
        return "行って" if verb == "行く" || verb == "いく"

        if group == :godan
          verb.chop + GODAN_MAPPING.fetch(verb[-1])
        else
          "#{stem}て" # te
        end
      end

      private

      def negative_te_form
        negative_plain_form.chop + "くて" # kute
      end
    end
  end
end

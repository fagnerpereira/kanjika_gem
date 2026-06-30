# frozen_string_literal: true

module Kanjika
  module Conjugator
    class Base
      # Japanese verb endings
      U_ENDINGS = "うくぐすつぬふぶむる" # u, ku, gu, su, tsu, nu, fu, bu, mu, ru
      A_ENDINGS = "わかがさたなはまら" # wa, ka, ga, sa, ta, na, ha, ma, ra
      E_ENDINGS = "えけげせてねへべめれ" # e, ke, ge, se, te, ne, he, be, me, re
      I_ENDINGS = "いきぎしちにひびみり" # i, ki, gi, shi, chi, ni, hi, bi, mi, ri

      # https://conjugator.reverso.net/conjugation-rules-model-japanese-info.html
      ICHIDAN_TYPE = :ichidan
      GODAN_TYPE = :godan
      IRREGULAR_TYPE = :irregular

      # Godan (ごだん) - five-step verb
      GODAN = "五段"
      # Ichidan (いちだん) - one-step verb
      ICHIDAN = "一段"
      # Suru (する) verb - irregular verb
      SURU = "サ変"
      # Kuru (くる) verb - irregular verb
      KURU = "カ変"
      # Noun verb (サ変接続) - noun that can be used as a suru verb
      NOUN_VERB = "サ変接続"

      IRREGULARS_STEM = {
        # Kuru (くる) -> Ki (き)
        "来る" => "来", # kuru -> ki
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
        return if verb.to_s.empty?

        return verb.chop if ichidan?
        return verb.tr(U_ENDINGS, I_ENDINGS) if godan?
        return verb.gsub("する", "し") if suru?
        IRREGULARS_STEM[verb]
      end

      def present
        {
          positive: {
            plain: verb,
            polite: "#{stem}ます"
          },
          negative: {
            plain: negative_plain_form,
            polite: "#{stem}ません"
          }
        }
      end

      def negative_plain_form
        if godan?
          # For godan verbs, transform u->a for negative
          verb.chop + verb[-1].tr(U_ENDINGS, A_ENDINGS) + "ない"
        else
          # For ichidan, suru, and irregular, use stem + ない
          "#{stem}ない"
        end
      end

      def conjugate
        raise NotImplementedError
      end

      def ichidan?
        inflection_types.any? { |t| t.include?(ICHIDAN) }
      end

      def godan?
        inflection_types.any? { |t| t.include?(GODAN) }
      end

      def suru?
        inflection_types.any? { |t| t.include?(SURU) || t.include?("サ行変") || t.include?(NOUN_VERB) }
      end

      def inflection_types
        process.flat_map do |word|
          word.tokens.map { |token| token[:inflection_type] }
        end.compact.flat_map { |type| type.split("・") }.uniq
      end

      def process
        return [] if verb.to_s.empty?
        @process ||= Ve.in(:ja).words(verb)
      end
    end
  end
end

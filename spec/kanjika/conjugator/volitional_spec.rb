# spec/kanjika/conjugator/volitional_spec.rb
require "spec_helper"

# Failing tests for the unimplemented Volitional form.
RSpec.describe Kanjika::Conjugator::Volitional do
  subject(:conjugator) { described_class.new(verb) }

  describe "#conjugate" do
    context "for godan verbs" do
      # Rule: Change final 'u' vowel to 'o' and add う
      verb_cases = {
        "書く" => "書こう",
        "泳ぐ" => "泳ごう",
        "飲む" => "飲もう",
        "買う" => "買おう"
      }

      verb_cases.each do |verb_str, expected|
        context "for verb '#{verb_str}'" do
          let(:verb) { verb_str }

          it "conjugates to '#{expected}'" do
            expect(conjugator.conjugate).to eq(expected)
          end
        end
      end
    end

    context "for ichidan verbs" do
      # Rule: Replace final る with よう
      verb_cases = {
        "食べる" => "食べよう",
        "見る" => "見よう",
        "起きる" => "起きよう"
      }

      verb_cases.each do |verb_str, expected|
        context "for verb '#{verb_str}'" do
          let(:verb) { verb_str }

          it "conjugates to '#{expected}'" do
            expect(conjugator.conjugate).to eq(expected)
          end
        end
      end
    end

    context "for irregular verbs" do
      verb_cases = {
        "する" => "しよう",
        "来る" => "来よう" # (koyou)
      }

      verb_cases.each do |verb_str, expected|
        context "for verb '#{verb_str}'" do
          let(:verb) { verb_str }

          it "conjugates to '#{expected}'" do
            expect(conjugator.conjugate).to eq(expected)
          end
        end
      end
    end
  end
end

# spec/kanjika/conjugator/causative_spec.rb
require "spec_helper"

# Failing tests for the unimplemented Causative form.
RSpec.describe Kanjika::Conjugator::Causative do
  subject(:conjugator) { described_class.new(verb) }

  describe "#conjugate" do
    context "for godan verbs" do
      # Rule: Change final 'u' vowel to 'a' and add せる
      verb_cases = {
        "書く" => "書かせる",
        "泳ぐ" => "泳がせる",
        "飲む" => "飲ませる",
        "買う" => "買わせる"
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
      # Rule: Replace final る with させる
      verb_cases = {
        "食べる" => "食べさせる",
        "見る" => "見させる",
        "起きる" => "起きさせる"
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
        "する" => "させる",
        "来る" => "来させる" # (kosaseru)
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

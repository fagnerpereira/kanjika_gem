# spec/kanjika/conjugator/passive_spec.rb
require "spec_helper"

# Failing tests for the unimplemented Passive form.
RSpec.describe Kanjika::Conjugator::Passive do
  subject(:conjugator) { described_class.new(verb) }

  describe "#conjugate" do
    context "for godan verbs" do
      # Rule: Change final 'u' vowel to 'a' and add れる
      verb_cases = {
        "書く" => "書かれる",
        "泳ぐ" => "泳がれる",
        "飲む" => "飲まれる",
        "買う" => "買われる"
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
      # Rule: Replace final る with られる
      verb_cases = {
        "食べる" => "食べられる",
        "見る" => "見られる",
        "起きる" => "起きられる"
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
        "する" => "される",
        "来る" => "来られる" # (korareru)
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

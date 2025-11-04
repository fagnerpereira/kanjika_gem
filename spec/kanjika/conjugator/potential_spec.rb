
# spec/kanjika/conjugator/potential_spec.rb
require 'spec_helper'

# Failing tests for the unimplemented Potential form.
RSpec.describe Kanjika::Conjugator::Potential do
  subject(:conjugator) { described_class.new(verb) }

  describe '#conjugate' do
    context 'for godan verbs' do
      # Rule: Change final 'u' vowel to 'e' and add る
      verb_cases = {
        "書く" => "書ける",
        "泳ぐ" => "泳げる",
        "飲む" => "飲める",
        "買う" => "買える"
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

    context 'for ichidan verbs' do
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

    context 'for irregular verbs' do
      verb_cases = {
        "する" => "できる",
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

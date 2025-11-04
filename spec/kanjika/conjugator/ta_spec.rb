# spec/kanjika/conjugator/ta_spec.rb
require "spec_helper"

# This is a new test file for a feature that does not exist yet.
# These tests will fail until the Kanjika::Conjugator::Ta class is implemented.
RSpec.describe Kanjika::Conjugator::Ta do
  subject(:conjugator) { described_class.new(verb) }

  describe "#conjugate" do
    describe "godan verbs" do
      # The -ta form rules are very similar to the -te form.
      # -te becomes -ta, -de becomes -da.
      verb_cases = {
        "う" => {"会う" => ["会った", "会わなかった"]},
        "つ" => {"待つ" => ["待った", "待たなかった"]},
        "る" => {"帰る" => ["帰った", "帰らなかった"]},
        "く" => {"書く" => ["書いた", "書かなかった"]},
        "ぐ" => {"泳ぐ" => ["泳いだ", "泳がなかった"]},
        "す" => {"話す" => ["話した", "話さなかった"]},
        "ぬ" => {"死ぬ" => ["死んだ", "死ななかった"]},
        "ぶ" => {"遊ぶ" => ["遊んだ", "遊ばなかった"]},
        "む" => {"読む" => ["読んだ", "読まなかった"]}
      }

      verb_cases.each do |ending, examples|
        context "with '#{ending}' ending" do
          examples.each do |verb_str, (positive, negative)|
            context "for verb '#{verb_str}'" do
              let(:verb) { verb_str }

              it "conjugates to '#{positive}' in positive form" do
                expect(conjugator.conjugate).to eq(positive)
              end

              it "conjugates to '#{negative}' in negative form" do
                expect(conjugator.conjugate(negative: true)).to eq(negative)
              end
            end
          end
        end
      end

      context "for special godan verb '行く'" do
        let(:verb) { "行く" }
        it "conjugates to '行った' (itta)" do
          expect(conjugator.conjugate).to eq("行った")
          expect(conjugator.conjugate(negative: true)).to eq("行かなかった")
        end
      end
    end

    describe "ichidan verbs" do
      verb_cases = {
        "食べる" => ["食べた", "食べなかった"],
        "見る" => ["見た", "見なかった"],
        "起きる" => ["起きた", "起きなかった"]
      }

      verb_cases.each do |verb_str, (positive, negative)|
        context "for verb '#{verb_str}'" do
          let(:verb) { verb_str }

          it "conjugates to '#{positive}' in positive form" do
            expect(conjugator.conjugate).to eq(positive)
          end

          it "conjugates to '#{negative}' in negative form" do
            expect(conjugator.conjugate(negative: true)).to eq(negative)
          end
        end
      end
    end

    describe "irregular verbs" do
      verb_cases = {
        "する" => ["した", "しなかった"],
        "勉強する" => ["勉強した", "勉強しなかった"],
        "来る" => ["来た", "来なかった"],
        "くる" => ["きた", "こなかった"]
      }

      verb_cases.each do |verb_str, (positive, negative)|
        context "for verb '#{verb_str}'" do
          let(:verb) { verb_str }

          it "conjugates to '#{positive}' in positive form" do
            expect(conjugator.conjugate).to eq(positive)
          end

          it "conjugates to '#{negative}' in negative form" do
            expect(conjugator.conjugate(negative: true)).to eq(negative)
          end
        end
      end
    end
  end
end

# spec/kanjika/conjugator/te_spec.rb
require "spec_helper"

RSpec.describe Kanjika::Conjugator::Te do
  subject(:conjugator) { described_class.new(verb) }

  describe "#conjugate" do
    describe "godan verbs" do
      verb_cases = {
        "う" => {"会う" => ["会って", "会わなくて"], "買う" => ["買って", "買わなくて"]},
        "つ" => {"待つ" => ["待って", "待たなくて"]},
        "る" => {"帰る" => ["帰って", "帰らなくて"]},
        "く" => {"書く" => ["書いて", "書かなくて"]},
        "ぐ" => {"泳ぐ" => ["泳いで", "泳がなくて"]},
        "す" => {"話す" => ["話して", "話さなくて"]},
        "ぬ" => {"死ぬ" => ["死んで", "死ななくて"]},
        "ぶ" => {"遊ぶ" => ["遊んで", "遊ばなくて"]},
        "む" => {"読む" => ["読んで", "読まなくて"]}
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

      # Special case for 行く (iku)
      context "for special godan verb '行く'" do
        let(:verb) { "行く" }
        it "conjugates to '行って' (itte)" do
          expect(conjugator.conjugate).to eq("行って")
          expect(conjugator.conjugate(negative: true)).to eq("行かなくて")
        end
      end
    end

    describe "ichidan verbs" do
      verb_cases = {
        "食べる" => ["食べて", "食べなくて"],
        "見る" => ["見て", "見なくて"],
        "起きる" => ["起きて", "起きなくて"]
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
        "する" => ["して", "しなくて"],
        "勉強する" => ["勉強して", "勉強しなくて"],
        "来る" => ["来て", "来なくて"],
        "くる" => ["きて", "こなくて"] # Note the negative form is different for hiragana
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

    describe "verbal nouns (suru verbs)" do
      let(:verb) { "勉強" }
      it "conjugates '勉強' to '勉強して'" do
        expect(conjugator.conjugate).to eq("勉強して")
        expect(conjugator.conjugate(negative: true)).to eq("勉強しなくて")
      end
    end

    describe "error and edge cases" do
      context "with an invalid verb" do
        let(:verb) { "きれい" } # na-adjective
        it "raises an InvalidVerbError" do
          expect { conjugator.conjugate }.to raise_error(Kanjika::InvalidVerbError, "'きれい' is not a valid verb")
        end
      end
    end
  end
end

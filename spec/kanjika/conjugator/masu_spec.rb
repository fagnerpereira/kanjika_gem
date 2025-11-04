# spec/kanjika/conjugator/masu_spec.rb
require "spec_helper"

RSpec.describe Kanjika::Conjugator::Masu do
  subject(:conjugator) { described_class.new(verb) }

  describe "#conjugate" do
    describe "godan verbs" do
      # Parameterized tests for each verb ending
      verb_cases = {
        "う" => {"会う" => ["会います", "会いません"], "使う" => ["使います", "使いません"]},
        "く" => {"書く" => ["書きます", "書きません"], "歩く" => ["歩きます", "歩きません"]},
        "ぐ" => {"泳ぐ" => ["泳ぎます", "泳ぎません"], "急ぐ" => ["急ぎます", "急ぎません"]},
        "す" => {"話す" => ["話します", "話しません"], "押す" => ["押します", "押しません"]},
        "つ" => {"持つ" => ["持ちます", "持ちません"], "待つ" => ["待ちます", "待ちません"]},
        "ぬ" => {"死ぬ" => ["死にます", "死にません"]},
        "ぶ" => {"飛ぶ" => ["飛びます", "飛びません"], "遊ぶ" => ["遊びます", "遊びません"]},
        "む" => {"読む" => ["読みます", "読みません"], "飲む" => ["飲みます", "飲みません"]},
        "る" => {"切る" => ["切ります", "切りません"], "走る" => ["走ります", "走りません"]}
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
    end

    describe "ichidan verbs" do
      verb_cases = {
        "食べる" => ["食べます", "食べません"],
        "見る" => ["見ます", "見ません"],
        "着る" => ["着ます", "着ません"],
        "寝る" => ["寝ます", "寝ません"],
        "たべる" => ["たべます", "たべません"],
        "みる" => ["みます", "みません"],
        "おきる" => ["おきます", "おきません"]
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
        "する" => ["します", "しません"],
        "勉強する" => ["勉強します", "勉強しません"],
        "くる" => ["きます", "きません"],
        "来る" => ["来ます", "来ません"],
        "ある" => ["あります", "ありません"]
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
      it "conjugates '勉強' to '勉強します'" do
        # This is a special case. The current logic might not handle it,
        # but a robust implementation should. Let's assume it should work.
        # If this test fails, it points to a logic improvement.
        expect(conjugator.conjugate).to eq("勉強します")
        expect(conjugator.conjugate(negative: true)).to eq("勉強しません")
      end
    end

    describe "edge cases and invalid inputs" do
      context "with non-verb input" do
        let(:verb) { "わたし" }
        it "returns the input unchanged" do
          expect(conjugator.conjugate).to eq("わたし")
        end
      end

      context "with an empty string" do
        let(:verb) { "" }
        it "returns an empty string" do
          # The Ve gem might raise an error here, which is fine.
          # A robust conjugator should probably handle this gracefully.
          expect { conjugator.conjugate }.not_to raise_error
          expect(conjugator.conjugate).to eq("")
        end
      end

      context "with nil input" do
        let(:verb) { nil }
        it "handles nil gracefully" do
          # Expecting it to not raise an error and return something sensible.
          expect { conjugator.conjugate }.not_to raise_error
        end
      end
    end
  end
end

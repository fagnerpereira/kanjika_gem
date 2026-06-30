# spec/kanjika/conjugator/base_spec.rb
require "spec_helper"

RSpec.describe Kanjika::Conjugator::Base do
  subject(:conjugator) { described_class.new(verb) }

  describe "#group" do
    verb_groups = {
      # Ichidan verbs (一段動詞 - ichidan dōshi)
      ichidan: %w[食べる 見る 起きる 教える],
      # Godan verbs (五段動詞 - godan dōshi)
      godan: %w[買う 書く 泳ぐ 話す 飲む],
      # Suru verbs (サ変動詞 - sahen dōshi)
      suru: %w[する 勉強する 愛する 接する],
      # Irregular verbs (変格動詞 - henkaku dōshi)
      irregular: %w[来る くる だ]
    }

    verb_groups.each do |group, verbs|
      context "for #{group} verbs" do
        verbs.each do |verb_str|
          it "identifies '#{verb_str}' as #{group}" do
            expect(described_class.new(verb_str).group).to eq(group)
          end
        end
      end
    end
  end

  describe "#process" do
    context "when verb is empty" do
      let(:verb) { "" }

      it "returns an empty array" do
        expect(conjugator.process).to eq([])
      end
    end

    context "when verb is nil" do
      let(:verb) { nil }

      it "returns an empty array" do
        expect(conjugator.process).to eq([])
      end
    end
  end

  describe "#stem" do
    stem_cases = {
      # Ichidan: remove る
      "食べる" => "食べ",
      "見る" => "見",
      # Godan: u -> i
      "書く" => "書き",
      "泳ぐ" => "泳ぎ",
      "飲む" => "飲み",
      "買う" => "買い",
      # Suru: する -> し
      "する" => "し",
      "勉強する" => "勉強し",
      # Irregular
      "来る" => "来",
      "くる" => "き"
    }

    stem_cases.each do |verb_str, stem|
      it "finds the stem of '#{verb_str}' to be '#{stem}'" do
        expect(described_class.new(verb_str).stem).to eq(stem)
      end
    end

    context "when verb is empty" do
      let(:verb) { "" }

      it "returns nil" do
        expect(conjugator.stem).to be_nil
      end
    end

    context "when verb is nil" do
      let(:verb) { nil }

      it "returns nil" do
        expect(conjugator.stem).to be_nil
      end
    end
  end

  describe "#present" do
    context "for an ichidan verb" do
      let(:verb) { "食べる" }
      let(:expected) do
        {
          positive: {plain: "食べる", polite: "食べます"},
          negative: {plain: "食べない", polite: "食べません"}
        }
      end

      it "returns a hash with all present tense forms" do
        expect(conjugator.present).to eq(expected)
      end
    end

    context "for a godan verb" do
      let(:verb) { "書く" }
      let(:expected) do
        {
          positive: {plain: "書く", polite: "書きます"},
          negative: {plain: "書かない", polite: "書きません"}
        }
      end

      it "returns a hash with all present tense forms" do
        expect(conjugator.present).to eq(expected)
      end
    end
  end
end

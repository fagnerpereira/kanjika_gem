# spec/kanjika/conjugator/base_spec.rb
require "spec_helper"

RSpec.describe Kanjika::Conjugator::Base do
  subject(:conjugator) { described_class.new(verb) }
  let(:verb) { "test" }

  describe "#inflection_types" do
    let(:word) { instance_double(Ve::Word) }

    before do
      allow(Ve).to receive_message_chain(:in, :words).with(verb).and_return([word])
    end

    it "returns the inflection types from tokens" do
      allow(word).to receive(:tokens).and_return([
        {inflection_type: "一段"}
      ])

      expect(conjugator.inflection_types).to eq(["一段"])
    end

    it "splits multiple inflection types separated by '・'" do
      allow(word).to receive(:tokens).and_return([
        {inflection_type: "五段・カ行"}
      ])

      expect(conjugator.inflection_types).to eq(["五段", "カ行"])
    end

    it "returns unique inflection types" do
      allow(word).to receive(:tokens).and_return([
        {inflection_type: "五段"},
        {inflection_type: "五段"}
      ])

      expect(conjugator.inflection_types).to eq(["五段"])
    end

    it "handles multiple words and tokens" do
      word2 = instance_double(Ve::Word)
      allow(Ve).to receive_message_chain(:in, :words).with(verb).and_return([word, word2])

      allow(word).to receive(:tokens).and_return([
        {inflection_type: "一段"}
      ])
      allow(word2).to receive(:tokens).and_return([
        {inflection_type: "助動詞"}
      ])

      expect(conjugator.inflection_types).to eq(["一段", "助動詞"])
    end

    it "compacts nil values" do
      allow(word).to receive(:tokens).and_return([
        {inflection_type: "一段"},
        {inflection_type: nil}
      ])

      expect(conjugator.inflection_types).to eq(["一段"])
    end

    context "when verb is empty" do
      let(:verb) { "" }

      it "returns an empty array" do
        expect(conjugator.inflection_types).to eq([])
      end
    end
  end

  describe "#group", :needs_mecab do
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

  describe "#stem", :needs_mecab do
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
  end

  describe "#present", :needs_mecab do
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

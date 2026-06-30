require "spec_helper"

RSpec.describe Kanjika::Conjugator::Base do
  describe "#ending_in_e_or_i?" do
    let(:conjugator) { described_class.new(verb) }
    subject { conjugator.ending_in_e_or_i? }

    context "with verbs ending in 'e' sound before final character" do
      [
        "たべる",   # ta-be-ru
        "食べる",   # ta-be-ru
        "教える",   # o-shi-e-ru
        "ねる",     # ne-ru
        "開ける",   # a-ke-ru
      ].each do |v|
        context "for '#{v}'" do
          let(:verb) { v }
          it { is_expected.to be true }
        end
      end
    end

    context "with verbs ending in 'i' sound before final character" do
      [
        "おきる",   # o-ki-ru
        "起きる",   # o-ki-ru
        "かりる",   # ka-ri-ru
        "借りる",   # ka-ri-ru
        "落ちる",   # o-chi-ru
      ].each do |v|
        context "for '#{v}'" do
          let(:verb) { v }
          it { is_expected.to be true }
        end
      end
    end

    context "with verbs NOT ending in 'e' or 'i' sound before final character" do
      [
        "かく",     # ka-ku
        "書く",     # ka-ku
        "よむ",     # yo-mu
        "読む",     # yo-mu
        "まつ",     # ma-tsu
        "待つ",     # ma-tsu
        "かう",     # ka-u
        "買う",     # ka-u
      ].each do |v|
        context "for '#{v}'" do
          let(:verb) { v }
          it { is_expected.to be false }
        end
      end
    end

    context "with edge cases" do
      context "with a single character verb" do
        let(:verb) { "う" }
        it { is_expected.to be false }
      end

      context "with an empty string" do
        let(:verb) { "" }
        it { is_expected.to be false }
      end

      context "with a verb where the sound is hidden in Kanji" do
        # In '見る' (mi-ru), 'mi' is '見'.
        # verb[-2] is '見'.
        # '見' is NOT in I_ENDINGS.
        let(:verb) { "見る" }
        it "returns false because it only checks Hiragana constants" do
          is_expected.to be false
        end
      end
    end
  end
end

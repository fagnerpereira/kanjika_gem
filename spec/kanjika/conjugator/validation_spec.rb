# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Conjugation validation" do
  # Godan verbs
  # Test cases based on research from Tofugu and Wikipedia
  context "for godan verbs" do
    it "conjugates '飲む' (nomu) correctly" do
      verb = Kanjika.verb("飲む")
      expect(verb.conjugate(:masu)).to eq("飲みます")
      expect(verb.conjugate(:te)).to eq("飲んで")
      expect(verb.conjugate(:potential)).to eq("飲める")
    end

    it "conjugates '呼ぶ' (yobu) correctly" do
      verb = Kanjika.verb("呼ぶ")
      expect(verb.conjugate(:masu)).to eq("呼びます")
      expect(verb.conjugate(:te)).to eq("呼んで")
      expect(verb.conjugate(:potential)).to eq("呼べる")
    end

    it "conjugates '死ぬ' (shinu) correctly" do
      verb = Kanjika.verb("死ぬ")
      expect(verb.conjugate(:masu)).to eq("死にます")
      expect(verb.conjugate(:te)).to eq("死んで")
      expect(verb.conjugate(:potential)).to eq("死ねる")
    end
  end

  # Ichidan verbs
  # Test cases based on research from Tofugu and Wikipedia
  context "for ichidan verbs" do
    it "conjugates '見る' (miru) correctly" do
      verb = Kanjika.verb("見る")
      expect(verb.conjugate(:masu)).to eq("見ます")
      expect(verb.conjugate(:te)).to eq("見て")
      expect(verb.conjugate(:potential)).to eq("見られる")
    end

    it "conjugates '起きる' (okiru) correctly" do
      verb = Kanjika.verb("起きる")
      expect(verb.conjugate(:masu)).to eq("起きます")
      expect(verb.conjugate(:te)).to eq("起きて")
      expect(verb.conjugate(:potential)).to eq("起きられる")
    end
  end

  # Irregular verbs
  # Test cases based on research from Tofugu and Wikipedia
  context "for irregular verbs" do
    it "conjugates '勉強する' (benkyou suru) correctly" do
      verb = Kanjika.verb("勉強する")
      expect(verb.conjugate(:masu)).to eq("勉強します")
      expect(verb.conjugate(:te)).to eq("勉強して")
      expect(verb.conjugate(:potential)).to eq("勉強できる")
    end
  end
end

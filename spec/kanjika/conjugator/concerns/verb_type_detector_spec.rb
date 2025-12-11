# frozen_string_literal: true

require "spec_helper"

RSpec.describe Kanjika::Conjugator::Concerns::VerbTypeDetector do
  # Create a test class that includes the concern
  let(:test_class) do
    Class.new(Kanjika::Conjugator::Base) do
      include Kanjika::Conjugator::Concerns::VerbTypeDetector
      public :determine_verb_type, :ichidan?, :godan?, :irregular?
    end
  end

  subject(:detector) { test_class.new(verb) }

  describe "#determine_verb_type" do
    context "for ichidan verbs" do
      let(:verb) { "食べる" }
      let(:token) { {inflection_type: "一段"} }

      it "returns :ichidan" do
        expect(detector.determine_verb_type(token)).to eq(:ichidan)
      end
    end

    context "for godan verbs" do
      let(:verb) { "書く" }
      let(:token) { {inflection_type: "五段"} }

      it "returns :godan" do
        expect(detector.determine_verb_type(token)).to eq(:godan)
      end
    end

    context "for suru verbs" do
      let(:verb) { "する" }
      let(:token) { {inflection_type: "サ変"} }

      it "returns :irregular" do
        expect(detector.determine_verb_type(token)).to eq(:irregular)
      end
    end

    context "for kuru verbs" do
      let(:verb) { "来る" }
      let(:token) { {inflection_type: "カ変"} }

      it "returns :irregular" do
        expect(detector.determine_verb_type(token)).to eq(:irregular)
      end
    end

    context "for compound inflection types" do
      let(:verb) { "食べる" }
      let(:token) { {inflection_type: "一段・基本形"} }

      it "correctly parses split inflection types" do
        expect(detector.determine_verb_type(token)).to eq(:ichidan)
      end
    end
  end

  describe "#ichidan?" do
    let(:verb) { "食べる" }

    it "returns true for ichidan inflection type" do
      token = {inflection_type: "一段"}
      expect(detector.ichidan?(token)).to be true
    end

    it "returns true for compound ichidan inflection type" do
      token = {inflection_type: "一段・基本形"}
      expect(detector.ichidan?(token)).to be true
    end

    it "returns false for non-ichidan inflection type" do
      token = {inflection_type: "五段"}
      expect(detector.ichidan?(token)).to be false
    end
  end

  describe "#godan?" do
    let(:verb) { "書く" }

    it "returns true for godan inflection type" do
      token = {inflection_type: "五段"}
      expect(detector.godan?(token)).to be true
    end

    it "returns true for compound godan inflection type" do
      token = {inflection_type: "五段・基本形"}
      expect(detector.godan?(token)).to be true
    end

    it "returns false for non-godan inflection type" do
      token = {inflection_type: "一段"}
      expect(detector.godan?(token)).to be false
    end
  end

  describe "#irregular?" do
    let(:verb) { "する" }

    it "returns true for suru verbs" do
      token = {inflection_type: "サ変"}
      expect(detector.irregular?(token)).to be true
    end

    it "returns true for kuru verbs" do
      token = {inflection_type: "カ変"}
      expect(detector.irregular?(token)).to be true
    end

    it "returns false for regular verbs" do
      token = {inflection_type: "五段"}
      expect(detector.irregular?(token)).to be false
    end
  end
end

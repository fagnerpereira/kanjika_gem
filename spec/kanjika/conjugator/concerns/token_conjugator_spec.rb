# frozen_string_literal: true

require "spec_helper"

RSpec.describe Kanjika::Conjugator::Concerns::TokenConjugator do
  # Create a test class that includes both concerns
  let(:test_class) do
    Class.new(Kanjika::Conjugator::Base) do
      include Kanjika::Conjugator::Concerns::VerbTypeDetector
      include Kanjika::Conjugator::Concerns::TokenConjugator

      attr_accessor :conjugation_result

      def conjugate_ichidan
        "ichidan_form"
      end

      def conjugate_godan
        "godan_form"
      end

      def conjugate_irregular
        "irregular_form"
      end

      def conjugate_others(token)
        token[:surface_form]
      end
    end
  end

  subject(:conjugator) { test_class.new(verb) }

  describe "#conjugate" do
    context "with ichidan verb" do
      let(:verb) { "食べる" }

      it "calls conjugate_ichidan for ichidan verbs" do
        expect(conjugator.conjugate).to eq("ichidan_form")
      end
    end

    context "with godan verb" do
      let(:verb) { "書く" }

      it "calls conjugate_godan for godan verbs" do
        expect(conjugator.conjugate).to eq("godan_form")
      end
    end

    context "with irregular verb (する)" do
      let(:verb) { "する" }

      it "calls conjugate_irregular for irregular verbs" do
        expect(conjugator.conjugate).to eq("irregular_form")
      end
    end

    context "with irregular verb (くる)" do
      let(:verb) { "くる" }

      it "calls conjugate_irregular for kuru verb" do
        expect(conjugator.conjugate).to eq("irregular_form")
      end
    end
  end

  describe "#apply_conjugation_rule" do
    let(:verb) { "書く" }

    it "handles ICHIDAN_TYPE constant correctly" do
      result = conjugator.send(:apply_conjugation_rule, Kanjika::Conjugator::Base::ICHIDAN_TYPE)
      expect(result).to eq("ichidan_form")
    end

    it "handles GODAN_TYPE constant correctly" do
      result = conjugator.send(:apply_conjugation_rule, Kanjika::Conjugator::Base::GODAN_TYPE)
      expect(result).to eq("godan_form")
    end

    it "handles IRREGULAR_TYPE constant correctly" do
      result = conjugator.send(:apply_conjugation_rule, Kanjika::Conjugator::Base::IRREGULAR_TYPE)
      expect(result).to eq("irregular_form")
    end

    it "raises ArgumentError for unknown verb type" do
      expect {
        conjugator.send(:apply_conjugation_rule, :unknown)
      }.to raise_error(ArgumentError, /Unknown or nil verb_type/)
    end

    it "raises ArgumentError for nil verb type" do
      expect {
        conjugator.send(:apply_conjugation_rule, nil)
      }.to raise_error(ArgumentError, /Unknown or nil verb_type/)
    end
  end

  describe "#conjugate_verb" do
    context "with ichidan verb token" do
      let(:verb) { "食べる" }
      let(:token) { {inflection_type: "一段", surface_form: "食べる"} }

      it "returns the correct conjugation" do
        result = conjugator.send(:conjugate_verb, token)
        expect(result).to eq("ichidan_form")
      end
    end

    context "with godan verb token" do
      let(:verb) { "書く" }
      let(:token) { {inflection_type: "五段", surface_form: "書く"} }

      it "returns the correct conjugation" do
        result = conjugator.send(:conjugate_verb, token)
        expect(result).to eq("godan_form")
      end
    end
  end

  describe "integration with real verb conjugation" do
    context "using Te conjugator" do
      subject(:te_conjugator) { Kanjika::Conjugator::Te.new(verb) }

      context "with godan verb" do
        let(:verb) { "書く" }

        it "conjugates correctly" do
          expect(te_conjugator.conjugate).to eq("書いて")
        end
      end

      context "with ichidan verb" do
        let(:verb) { "食べる" }

        it "conjugates correctly" do
          expect(te_conjugator.conjugate).to eq("食べて")
        end
      end
    end

    context "using Masu conjugator" do
      subject(:masu_conjugator) { Kanjika::Conjugator::Masu.new(verb) }

      context "with godan verb" do
        let(:verb) { "書く" }

        it "conjugates correctly" do
          expect(masu_conjugator.conjugate).to eq("書きます")
        end
      end

      context "with ichidan verb" do
        let(:verb) { "食べる" }

        it "conjugates correctly" do
          expect(masu_conjugator.conjugate).to eq("食べます")
        end
      end
    end

    context "using Potential conjugator" do
      subject(:potential_conjugator) { Kanjika::Conjugator::Potential.new(verb) }

      context "with godan verb" do
        let(:verb) { "書く" }

        it "conjugates correctly" do
          expect(potential_conjugator.conjugate).to eq("書ける")
        end
      end

      context "with ichidan verb" do
        let(:verb) { "食べる" }

        it "conjugates correctly" do
          expect(potential_conjugator.conjugate).to eq("食べられる")
        end
      end
    end
  end
end

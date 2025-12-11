# frozen_string_literal: true

require "spec_helper"

RSpec.describe Kanjika::Conjugator::Masu do
  subject(:conjugator) { described_class.new(verb) }

  describe "#conjugate" do
    context 'for godan verb "書く"' do
      let(:verb) { "書く" }

      it { expect(conjugator.conjugate).to eq("書きます") }
      it { expect(conjugator.conjugate(negative: true)).to eq("書きません") }
    end

    context 'for ichidan verb "食べる"' do
      let(:verb) { "食べる" }

      it { expect(conjugator.conjugate).to eq("食べます") }
      it { expect(conjugator.conjugate(negative: true)).to eq("食べません") }
    end

    context 'for irregular verb "する"' do
      let(:verb) { "する" }

      it { expect(conjugator.conjugate).to eq("します") }
      it { expect(conjugator.conjugate(negative: true)).to eq("しません") }
    end

    context 'for irregular verb "来る"' do
      let(:verb) { "来る" }

      it { expect(conjugator.conjugate).to eq("来ます") }
      it { expect(conjugator.conjugate(negative: true)).to eq("来ません") }
    end
  end
end

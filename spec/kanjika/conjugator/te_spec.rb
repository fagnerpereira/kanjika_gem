# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kanjika::Conjugator::Te do
  subject(:conjugator) { described_class.new(verb) }

  describe '#conjugate' do
    context 'for godan verb "書く"' do
      let(:verb) { '書く' }

      it { expect(conjugator.conjugate).to eq('書いて') }
      it { expect(conjugator.conjugate(negative: true)).to eq('書かなくて') }
    end

    context 'for special godan verb "行く"' do
      let(:verb) { '行く' }

      it { expect(conjugator.conjugate).to eq('行って') }
      it { expect(conjugator.conjugate(negative: true)).to eq('行かなくて') }
    end

    context 'for ichidan verb "食べる"' do
      let(:verb) { '食べる' }

      it { expect(conjugator.conjugate).to eq('食べて') }
      it { expect(conjugator.conjugate(negative: true)).to eq('食べなくて') }
    end

    context 'for irregular verb "する"' do
      let(:verb) { 'する' }

      it { expect(conjugator.conjugate).to eq('して') }
      it { expect(conjugator.conjugate(negative: true)).to eq('しなくて') }
    end

    context 'for irregular verb "来る"' do
      let(:verb) { '来る' }

      it { expect(conjugator.conjugate).to eq('来て') }
      it { expect(conjugator.conjugate(negative: true)).to eq('来なくて') }
    end
  end
end

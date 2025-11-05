# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kanjika::Conjugator::Potential do
  subject(:conjugator) { described_class.new(verb) }

  describe '#conjugate' do
    context 'for godan verb "書く"' do
      let(:verb) { '書く' }

      it { expect(conjugator.conjugate).to eq('書ける') }
    end

    context 'for ichidan verb "食べる"' do
      let(:verb) { '食べる' }

      it { expect(conjugator.conjugate).to eq('食べられる') }
    end

    context 'for irregular verb "する"' do
      let(:verb) { 'する' }

      it { expect(conjugator.conjugate).to eq('できる') }
    end

    context 'for irregular verb "来る"' do
      let(:verb) { '来る' }

      it { expect(conjugator.conjugate).to eq('来られる') }
    end
  end
end

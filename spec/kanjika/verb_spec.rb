# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kanjika::Verb do
  describe '#conjugate' do
    context 'for godan verb "書く"' do
      let(:verb) { Kanjika.verb('書く') }

      it 'conjugates to masu form' do
        expect(verb.conjugate(:masu)).to eq('書きます')
      end

      it 'conjugates to te form' do
        expect(verb.conjugate(:te)).to eq('書いて')
      end

      it 'conjugates to potential form' do
        expect(verb.conjugate(:potential)).to eq('書ける')
      end
    end

    context 'for ichidan verb "食べる"' do
      let(:verb) { Kanjika.verb('食べる') }

      it 'conjugates to masu form' do
        expect(verb.conjugate(:masu)).to eq('食べます')
      end

      it 'conjugates to te form' do
        expect(verb.conjugate(:te)).to eq('食べて')
      end

      it 'conjugates to potential form' do
        expect(verb.conjugate(:potential)).to eq('食べられる')
      end
    end

    context 'for irregular verb "する"' do
      let(:verb) { Kanjika.verb('する') }

      it 'conjugates to masu form' do
        expect(verb.conjugate(:masu)).to eq('します')
      end

      it 'conjugates to te form' do
        expect(verb.conjugate(:te)).to eq('して')
      end

      it 'conjugates to potential form' do
        expect(verb.conjugate(:potential)).to eq('できる')
      end
    end

    context 'for irregular verb "来る"' do
      let(:verb) { Kanjika.verb('来る') }

      it 'conjugates to masu form' do
        expect(verb.conjugate(:masu)).to eq('来ます')
      end

      it 'conjugates to te form' do
        expect(verb.conjugate(:te)).to eq('来て')
      end

      it 'conjugates to potential form' do
        expect(verb.conjugate(:potential)).to eq('来られる')
      end
    end
  end
end

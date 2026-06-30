# frozen_string_literal: true

require "spec_helper"

RSpec.describe Kanjika::Verb do
  describe "#conjugate" do
    # Godan verb "書く" (kaku)
    context 'for godan verb "書く"', :needs_mecab do
      let(:verb) { Kanjika.verb("書く") }

      it "conjugates to masu form" do
        expect(verb.conjugate(:masu)).to eq("書きます") # kakimasu
      end

      it "conjugates to te form" do
        expect(verb.conjugate(:te)).to eq("書いて") # kaite
      end

      it "conjugates to potential form" do
        expect(verb.conjugate(:potential)).to eq("書ける") # kakeru
      end
    end

    # Ichidan verb "食べる" (taberu)
    context 'for ichidan verb "食べる"', :needs_mecab do
      let(:verb) { Kanjika.verb("食べる") }

      it "conjugates to masu form" do
        expect(verb.conjugate(:masu)).to eq("食べます") # tabemasu
      end

      it "conjugates to te form" do
        expect(verb.conjugate(:te)).to eq("食べて") # tabete
      end

      it "conjugates to potential form" do
        expect(verb.conjugate(:potential)).to eq("食べられる") # taberareru
      end
    end

    # Irregular verb "する" (suru)
    context 'for irregular verb "する"', :needs_mecab do
      let(:verb) { Kanjika.verb("する") }

      it "conjugates to masu form" do
        expect(verb.conjugate(:masu)).to eq("します") # shimasu
      end

      it "conjugates to te form" do
        expect(verb.conjugate(:te)).to eq("して") # shite
      end

      it "conjugates to potential form" do
        expect(verb.conjugate(:potential)).to eq("できる") # dekiru
      end
    end

    # Irregular verb "来る" (kuru)
    context 'for irregular verb "来る"', :needs_mecab do
      let(:verb) { Kanjika.verb("来る") }

      it "conjugates to masu form" do
        expect(verb.conjugate(:masu)).to eq("来ます") # kimasu
      end

      it "conjugates to te form" do
        expect(verb.conjugate(:te)).to eq("来て") # kite
      end

      it "conjugates to potential form" do
        expect(verb.conjugate(:potential)).to eq("来られる") # korareru
      end
    end

    context "when given invalid or nil forms" do
      let(:verb) { Kanjika.verb("食べる") }

      it "raises an error when form type is unknown" do
        expect { verb.conjugate(:unknown_form) }.to raise_error(RuntimeError, /Unknown form unknown_form/)
      end

      it "raises a clean error when form type is nil" do
        expect { verb.conjugate(nil) }.to raise_error(RuntimeError, /Unknown form/)
      end
    end
  end
end

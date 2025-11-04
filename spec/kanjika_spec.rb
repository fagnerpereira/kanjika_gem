# frozen_string_literal: true

RSpec.describe Kanjika do
  it "has a version number" do
    expect(Kanjika::VERSION).not_to be nil
  end

  describe ".conjugate" do
    it "conjugates a verb to the specified form" do
      expect(Kanjika.conjugate("食べる", :masu)).to eq("食べます")
      expect(Kanjika.conjugate("書く", :te)).to eq("書いて")
    end

    it "handles negative conjugations" do
      expect(Kanjika.conjugate("食べる", :masu, negative: true)).to eq("食べません")
    end

    it "raises an error for unknown forms" do
      expect { Kanjika.conjugate("食べる", :unknown) }.to raise_error("Unknown form unknown")
    end
  end

  describe ".verb" do
    it "returns a Verb object" do
      expect(Kanjika.verb("食べる")).to be_a(Kanjika::Verb)
    end

    describe "#to" do
      it "conjugates the verb to the specified form" do
        expect(Kanjika.verb("食べる").to(:masu)).to eq("食べます")
        expect(Kanjika.verb("書く").to(:te)).to eq("書いて")
      end

      it "handles negative conjugations" do
        expect(Kanjika.verb("食べる").to(:masu, negative: true)).to eq("食べません")
      end
    end
  end
end

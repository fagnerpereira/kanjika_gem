require "spec_helper"

RSpec.describe Kanjika::Verb do
  let(:ichidan_verb) { described_class.new("食べる") }
  let(:godan_verb) { described_class.new("書く") }
  let(:irregular_verb) { described_class.new("する") }

  describe "#initialize" do
    it "stores the verb string" do
      expect(ichidan_verb.verb_string).to eq("食べる")
    end
  end

  describe "#masu" do
    it "conjugates ichidan verbs to masu form" do
      expect(ichidan_verb.masu).to eq("食べます")
    end

    it "conjugates godan verbs to masu form" do
      expect(godan_verb.masu).to eq("書きます")
    end

    it "conjugates to negative masu form" do
      expect(ichidan_verb.masu(negative: true)).to eq("食べません")
    end
  end

  describe "#te" do
    it "conjugates ichidan verbs to te form" do
      expect(ichidan_verb.te).to eq("食べて")
    end

    it "conjugates godan verbs to te form" do
      expect(godan_verb.te).to eq("書いて")
    end

    it "conjugates to negative te form" do
      expect(ichidan_verb.te(negative: true)).to eq("食べなくて")
    end
  end

  describe "#ta" do
    it "conjugates ichidan verbs to ta form" do
      expect(ichidan_verb.ta).to eq("食べた")
    end

    it "conjugates godan verbs to ta form" do
      expect(godan_verb.ta).to eq("書いた")
    end

    it "conjugates to negative ta form" do
      expect(ichidan_verb.ta(negative: true)).to eq("食べなかった")
    end
  end

  describe "#causative" do
    it "conjugates ichidan verbs to causative form" do
      expect(ichidan_verb.causative).to eq("食べさせる")
    end

    it "conjugates godan verbs to causative form" do
      expect(godan_verb.causative).to eq("書かせる")
    end
  end

  describe "#passive" do
    it "conjugates ichidan verbs to passive form" do
      expect(ichidan_verb.passive).to eq("食べられる")
    end

    it "conjugates godan verbs to passive form" do
      expect(godan_verb.passive).to eq("書かれる")
    end
  end

  describe "#potential" do
    it "conjugates ichidan verbs to potential form" do
      expect(ichidan_verb.potential).to eq("食べられる")
    end

    it "conjugates godan verbs to potential form" do
      expect(godan_verb.potential).to eq("書ける")
    end
  end

  describe "#volitional" do
    it "conjugates ichidan verbs to volitional form" do
      expect(ichidan_verb.volitional).to eq("食べよう")
    end

    it "conjugates godan verbs to volitional form" do
      expect(godan_verb.volitional).to eq("書こう")
    end
  end

  describe "#all_forms" do
    it "returns all conjugation forms" do
      forms = ichidan_verb.all_forms
      expect(forms).to be_a(Hash)
      expect(forms[:dictionary]).to eq("食べる")
      expect(forms[:masu][:positive]).to eq("食べます")
      expect(forms[:te][:positive]).to eq("食べて")
      expect(forms[:causative]).to eq("食べさせる")
    end
  end

  describe "analysis methods" do
    describe "#group" do
      it "identifies ichidan verbs" do
        expect(ichidan_verb.group).to eq(:ichidan)
      end

      it "identifies godan verbs" do
        expect(godan_verb.group).to eq(:godan)
      end

      it "identifies irregular verbs" do
        expect(irregular_verb.group).to eq(:suru)
      end
    end

    describe "#stem" do
      it "returns the stem of ichidan verbs" do
        expect(ichidan_verb.stem).to eq("食べ")
      end

      it "returns the stem of godan verbs" do
        expect(godan_verb.stem).to eq("書き")
      end
    end

    describe "#ichidan?" do
      it "returns true for ichidan verbs" do
        expect(ichidan_verb.ichidan?).to be true
      end

      it "returns false for non-ichidan verbs" do
        expect(godan_verb.ichidan?).to be false
      end
    end

    describe "#godan?" do
      it "returns true for godan verbs" do
        expect(godan_verb.godan?).to be true
      end

      it "returns false for non-godan verbs" do
        expect(ichidan_verb.godan?).to be false
      end
    end

    describe "#present" do
      it "returns present tense forms" do
        present = ichidan_verb.present
        expect(present).to be_a(Hash)
        expect(present[:positive][:plain]).to eq("食べる")
        expect(present[:positive][:polite]).to eq("食べます")
        expect(present[:negative][:plain]).to eq("食べない")
        expect(present[:negative][:polite]).to eq("食べません")
      end
    end
  end

  describe "aliases" do
    it "#polite is alias for #masu" do
      expect(ichidan_verb.polite).to eq(ichidan_verb.masu)
    end

    it "#past is alias for #ta" do
      expect(ichidan_verb.past).to eq(ichidan_verb.ta)
    end

    it "#make_do is alias for #causative" do
      expect(ichidan_verb.make_do).to eq(ichidan_verb.causative)
    end

    it "#can_do is alias for #potential" do
      expect(ichidan_verb.can_do).to eq(ichidan_verb.potential)
    end

    it "#lets_do is alias for #volitional" do
      expect(ichidan_verb.lets_do).to eq(ichidan_verb.volitional)
    end
  end

  describe "#to_s" do
    it "returns the verb string" do
      expect(ichidan_verb.to_s).to eq("食べる")
    end
  end

  describe "#inspect" do
    it "returns a readable representation" do
      expect(ichidan_verb.inspect).to eq("#<Kanjika::Verb 食べる (ichidan)>")
    end
  end
end

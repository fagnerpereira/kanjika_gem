RSpec.describe Kanjika::Conjugator::Base do
  describe "#group" do
    context "ichidan verbs" do
      it do
        conjugator = described_class.new("食べる")
        expect(conjugator.group).to eq(:ichidan)
      end
    end

    context "godan verbs" do
      it do
        conjugator = described_class.new("買う")
        expect(conjugator.group).to eq(:godan)
      end
    end

    context "suru verbs" do
      it "returns suru" do
        expect(described_class.new("する").group).to eq(:suru)
        expect(described_class.new("勉強する").group).to eq(:suru)
        expect(described_class.new("愛する").group).to eq(:suru)
        expect(described_class.new("接する").group).to eq(:suru)
      end
    end

    context "irregular verbs" do
      it do
        expect(described_class.new("来る").group).to eq(:irregular)
        expect(described_class.new("だ").group).to eq(:irregular)
        # expect(described_class.new("有る").group).to eq(:irregular)
        # expect(described_class.new("在る").group).to eq(:irregular)
        # expect(described_class.new("行く").group).to eq(:irregular)
        # expect(described_class.new("くれる").group).to eq(:irregular)
        # expect(described_class.new("なさる").group).to eq(:irregular)
        # expect(described_class.new("問う").group).to eq(:irregular)
        # expect(described_class.new("請う").group).to eq(:irregular)
      end
    end
  end
end

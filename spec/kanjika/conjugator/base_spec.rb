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
      it do
        conjugator = described_class.new("勉強する")
        expect(conjugator.group).to eq(:suru)
      end
    end
  end
end

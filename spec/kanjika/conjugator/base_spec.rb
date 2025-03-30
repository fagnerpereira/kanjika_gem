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

  describe "#stem" do
    context "ichidan verbs" do
      it "removes the last character" do
        expect(described_class.new("食べる").stem).to eq("食べ")
        expect(described_class.new("見る").stem).to eq("見")
        expect(described_class.new("起きる").stem).to eq("起き")
        expect(described_class.new("教える").stem).to eq("教え")
      end
    end

    context "godan verbs" do
      it "replaces u with i" do
        expect(described_class.new("書く").stem).to eq("書き")
        expect(described_class.new("泳ぐ").stem).to eq("泳ぎ")
        expect(described_class.new("話す").stem).to eq("話し")
        expect(described_class.new("飲む").stem).to eq("飲み")
        expect(described_class.new("死ぬ").stem).to eq("死に")
        expect(described_class.new("遊ぶ").stem).to eq("遊び")
        expect(described_class.new("買う").stem).to eq("買い")
        expect(described_class.new("立つ").stem).to eq("立ち")
        expect(described_class.new("取る").stem).to eq("取り")
      end
    end

    context "suru verbs" do
      it "replaces by shi" do
        expect(described_class.new("する").stem).to eq("し")
        expect(described_class.new("勉強する").stem).to eq("勉強し")
        expect(described_class.new("愛する").stem).to eq("愛し")
        expect(described_class.new("接する").stem).to eq("接し")
      end
    end

    context "irregular verbs" do
      it do
        expect(described_class.new("来る").stem).to eq("来")
        expect(described_class.new("くる").stem).to eq("き")
      end
    end
  end

  describe "#present" do
    context "ichidan verbs" do
      it do
        conjugator = described_class.new("食べる")
        expect(conjugator.present).to match({
          positive: {
            plain: "食べる",
            polite: "食べます"
          },
          negative: {
            plain: "食べない",
            polite: "食べません"
          }
        })
      end
    end

    context "godan verbs" do
      it do
        conjugator = described_class.new("買う")
        expect(conjugator.present).to match({
          positive: {
            plain: "買う",
            polite: "買います"
          },
          negative: {
            plain: "買わない",
            polite: "買いません"
          }
        })
      end
    end
  end
end

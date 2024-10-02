RSpec.describe Kanjika::Conjugator::Masu do
  describe ".conjugate" do
    context "godan verbs (u endings)" do
      it { expect(described_class.conjugate("ある")).to eq("あります") }
      it { expect(described_class.conjugate("有る")).to eq("有ります") }
      it { expect(described_class.conjugate("切る")).to eq("切ります") }
      it { expect(described_class.conjugate("はしる")).to eq("はしります") }
      it { expect(described_class.conjugate("しる")).to eq("しります") }
      it { expect(described_class.conjugate("会う")).to eq("会います") }
      it { expect(described_class.conjugate("書く")).to eq("書きます") }
      it { expect(described_class.conjugate("泳ぐ")).to eq("泳ぎます") }
      it { expect(described_class.conjugate("話す")).to eq("話します") }
      it { expect(described_class.conjugate("持つ")).to eq("持ちます") }
      it { expect(described_class.conjugate("死ぬ")).to eq("死にます") }
      it { expect(described_class.conjugate("飛ぶ")).to eq("飛びます") }
      it { expect(described_class.conjugate("読む")).to eq("読みます") }
    end

    context "ichidan verbs (ru endings)" do
      it { expect(described_class.conjugate("いる")).to eq("います") }
      it { expect(described_class.conjugate("おきる")).to eq("おきます") }
      it { expect(described_class.conjugate("きる")).to eq("きます") }
      it { expect(described_class.conjugate("着る")).to eq("着ます") }
      it { expect(described_class.conjugate("たべる")).to eq("たべます") }
      it { expect(described_class.conjugate("食べる")).to eq("食べます") }
      it { expect(described_class.conjugate("見る")).to eq("見ます") }
      it { expect(described_class.conjugate("みる")).to eq("みます") }
    end

    context "irregular verbs" do
      it { expect(described_class.conjugate("来る")).to eq("来ます") }
      it { expect(described_class.conjugate("くる")).to eq("きます") }
      it { expect(described_class.conjugate("する")).to eq("します") }
    end

    context "kanji noun verbs" do
      # 愛用 (aiyou) - to love and use, to favor
      # 改正 (kaisei) - to revise, to amend
      # 断然 (danzen) - to decide firmly
      # 完了 (kanryou) - to complete, to finish
      # 存在 (sonzai) - to exist
      # 感謝 (kansha) - to thank, to be grateful
      # 理解 (rikai) - to understand
      # 実行 (jikkou) - to carry out, to put into practice
      # 了解 (ryoukai) - to understand, to comprehend
      # 確認 (kakunin) - to confirm, to verify
      # 勉強
      it { expect(described_class.conjugate("愛用")).to eq("愛用します") }
    end

    context "invalid verbs" do
      it do
        expect(described_class.conjugate("わたし")).to eq("")
      end
    end
  end
end

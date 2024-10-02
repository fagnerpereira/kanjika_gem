RSpec.describe Kanjika::Conjugator::Te do
  describe ".conjugate" do
    context "godan verbs (u endings)" do
      context "verbs ending with う, つ, る" do
        it "substitutes for 'って'" do
          expect(described_class.conjugate("有る")).to eq("有って")
          expect(described_class.conjugate("会う")).to eq("会って")
          expect(described_class.conjugate("持つ")).to eq("持って")
        end
      end

      context "verbs ending with む, ぶ, ぬ" do
        it "substitutes for 'んで'" do
          expect(described_class.conjugate("死ぬ")).to eq("死んで")
          expect(described_class.conjugate("飛ぶ")).to eq("飛んで")
          expect(described_class.conjugate("読む")).to eq("読んで")
        end
      end

      context "verbs ending with く" do
        it "substitutes 'く' for 'いて'" do
          expect(described_class.conjugate("書く")).to eq("書いて")
        end
      end

      context "verbs ending with ぐ" do
        it "substitutes 'ぐ' for 'いで' " do
          expect(described_class.conjugate("泳ぐ")).to eq("泳いで")
        end
      end

      context "verbs ending with す" do
        it "substitutes 'す' for 'して'" do
          expect(described_class.conjugate("話す")).to eq("話して")
        end
      end
    end

    context "ichidan verbs (ru endings)" do
      it "removes 'る', adds 'て'" do
        expect(described_class.conjugate("いる")).to eq("いて")
        expect(described_class.conjugate("おきる")).to eq("おきて")
        expect(described_class.conjugate("きる")).to eq("きて")
        expect(described_class.conjugate("着る")).to eq("着て")
        expect(described_class.conjugate("たべる")).to eq("たべて")
        expect(described_class.conjugate("食べる")).to eq("食べて")
        expect(described_class.conjugate("見る")).to eq("見て")
        expect(described_class.conjugate("みる")).to eq("みて")
      end
    end

    context "irregular verbs" do
      it { expect(described_class.conjugate("来る")).to eq("来て") }
      it { expect(described_class.conjugate("くる")).to eq("きて") }
      it { expect(described_class.conjugate("する")).to eq("して") }
    end

    context "kanji noun verbs" do
      it "adds 'して'" do
        expect(described_class.conjugate("愛用")).to eq("愛用して")
        expect(described_class.conjugate("改正")).to eq("改正して")
        expect(described_class.conjugate("完了")).to eq("完了して")
        expect(described_class.conjugate("存在")).to eq("存在して")
        expect(described_class.conjugate("感謝")).to eq("感謝して")
        expect(described_class.conjugate("理解")).to eq("理解して")
        expect(described_class.conjugate("実行")).to eq("実行して")
        expect(described_class.conjugate("了解")).to eq("了解して")
        expect(described_class.conjugate("確認")).to eq("確認して")
        expect(described_class.conjugate("勉強")).to eq("勉強して")
        expect(described_class.conjugate("愛用")).to eq("愛用して")
      end

      context "invalid verbs" do
        it "returns 'invalid verb'" do
          expect(described_class.conjugate("断然")).to eq("invalid verb")
          expect(described_class.conjugate("わたし")).to eq("invalid verb")
        end
      end
    end
  end
end

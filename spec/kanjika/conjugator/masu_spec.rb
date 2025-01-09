RSpec.describe Kanjika::Conjugator::Masu do
  describe "#conjugate" do
    # Godan verbs are grouped by their ending sound
    describe "godan verbs" do
      describe "う ending verbs" do
        it "conjugates 会う (to meet)" do
          conjugator = described_class.new("会う")
          expect(conjugator.conjugate).to eq("会います")
          expect(conjugator.conjugate(negative: true)).to eq("会いません")
        end

        it "conjugates 使う (to use)" do
          conjugator = described_class.new("使う")
          expect(conjugator.conjugate).to eq("使います")
          expect(conjugator.conjugate(negative: true)).to eq("使いません")
        end

        it "conjugates 買う (to buy)" do
          conjugator = described_class.new("買う")
          expect(conjugator.conjugate).to eq("買います")
          expect(conjugator.conjugate(negative: true)).to eq("買いません")
        end
      end

      describe "く ending verbs" do
        it "conjugates 書く (to write)" do
          conjugator = described_class.new("書く")
          expect(conjugator.conjugate).to eq("書きます")
          expect(conjugator.conjugate(negative: true)).to eq("書きません")
        end

        it "conjugates 歩く (to walk)" do
          conjugator = described_class.new("歩く")
          expect(conjugator.conjugate).to eq("歩きます")
          expect(conjugator.conjugate(negative: true)).to eq("歩きません")
        end
      end

      describe "ぐ ending verbs" do
        it "conjugates 泳ぐ (to swim)" do
          conjugator = described_class.new("泳ぐ")
          expect(conjugator.conjugate).to eq("泳ぎます")
          expect(conjugator.conjugate(negative: true)).to eq("泳ぎません")
        end

        it "conjugates 急ぐ (to hurry)" do
          conjugator = described_class.new("急ぐ")
          expect(conjugator.conjugate).to eq("急ぎます")
          expect(conjugator.conjugate(negative: true)).to eq("急ぎません")
        end
      end

      describe "す ending verbs" do
        it "conjugates 話す (to speak)" do
          conjugator = described_class.new("話す")
          expect(conjugator.conjugate).to eq("話します")
          expect(conjugator.conjugate(negative: true)).to eq("話しません")
        end

        it "conjugates 押す (to push)" do
          conjugator = described_class.new("押す")
          expect(conjugator.conjugate).to eq("押します")
          expect(conjugator.conjugate(negative: true)).to eq("押しません")
        end
      end

      describe "つ ending verbs" do
        it "conjugates 持つ (to hold)" do
          conjugator = described_class.new("持つ")
          expect(conjugator.conjugate).to eq("持ちます")
          expect(conjugator.conjugate(negative: true)).to eq("持ちません")
        end

        it "conjugates 待つ (to wait)" do
          conjugator = described_class.new("待つ")
          expect(conjugator.conjugate).to eq("待ちます")
          expect(conjugator.conjugate(negative: true)).to eq("待ちません")
        end
      end

      describe "ぬ ending verbs" do
        it "conjugates 死ぬ (to die)" do
          conjugator = described_class.new("死ぬ")
          expect(conjugator.conjugate).to eq("死にます")
          expect(conjugator.conjugate(negative: true)).to eq("死にません")
        end
      end

      describe "ぶ ending verbs" do
        it "conjugates 飛ぶ (to fly)" do
          conjugator = described_class.new("飛ぶ")
          expect(conjugator.conjugate).to eq("飛びます")
          expect(conjugator.conjugate(negative: true)).to eq("飛びません")
        end

        it "conjugates 遊ぶ (to play)" do
          conjugator = described_class.new("遊ぶ")
          expect(conjugator.conjugate).to eq("遊びます")
          expect(conjugator.conjugate(negative: true)).to eq("遊びません")
        end
      end

      describe "む ending verbs" do
        it "conjugates 読む (to read)" do
          conjugator = described_class.new("読む")
          expect(conjugator.conjugate).to eq("読みます")
          expect(conjugator.conjugate(negative: true)).to eq("読みません")
        end

        it "conjugates 飲む (to drink)" do
          conjugator = described_class.new("飲む")
          expect(conjugator.conjugate).to eq("飲みます")
          expect(conjugator.conjugate(negative: true)).to eq("飲みません")
        end
      end

      describe "る ending verbs (godan)" do
        it "conjugates 切る (to cut)" do
          conjugator = described_class.new("切る")
          expect(conjugator.conjugate).to eq("切ります")
          expect(conjugator.conjugate(negative: true)).to eq("切りません")
        end

        it "conjugates 走る (to run)" do
          conjugator = described_class.new("走る")
          expect(conjugator.conjugate).to eq("走ります")
          expect(conjugator.conjugate(negative: true)).to eq("走りません")
        end
      end
    end

    # Ichidan verbs all end in る but have different conjugation rules
    describe "ichidan verbs" do
      describe "verbs with kanji" do
        it "conjugates 食べる (to eat)" do
          conjugator = described_class.new("食べる")
          expect(conjugator.conjugate).to eq("食べます")
          expect(conjugator.conjugate(negative: true)).to eq("食べません")
        end

        it "conjugates 見る (to see)" do
          conjugator = described_class.new("見る")
          expect(conjugator.conjugate).to eq("見ます")
          expect(conjugator.conjugate(negative: true)).to eq("見ません")
        end

        it "conjugates 着る (to wear)" do
          conjugator = described_class.new("着る")
          expect(conjugator.conjugate).to eq("着ます")
          expect(conjugator.conjugate(negative: true)).to eq("着ません")
        end

        it "conjugates 寝る (to sleep)" do
          conjugator = described_class.new("寝る")
          expect(conjugator.conjugate).to eq("寝ます")
          expect(conjugator.conjugate(negative: true)).to eq("寝ません")
        end
      end

      describe "verbs without kanji" do
        it "conjugates たべる (to eat)" do
          conjugator = described_class.new("たべる")
          expect(conjugator.conjugate).to eq("たべます")
          expect(conjugator.conjugate(negative: true)).to eq("たべません")
        end

        it "conjugates みる (to see)" do
          conjugator = described_class.new("みる")
          expect(conjugator.conjugate).to eq("みます")
          expect(conjugator.conjugate(negative: true)).to eq("みません")
        end

        it "conjugates おきる (to wake up)" do
          conjugator = described_class.new("おきる")
          expect(conjugator.conjugate).to eq("おきます")
          expect(conjugator.conjugate(negative: true)).to eq("おきません")
        end
      end
    end

    # Irregular verbs follow their own unique conjugation patterns
    describe "irregular verbs" do
      describe "する verbs" do
        it "conjugates する (to do)" do
          conjugator = described_class.new("する")
          expect(conjugator.conjugate).to eq("します")
          expect(conjugator.conjugate(negative: true)).to eq("しません")
        end

        it "conjugates 勉強する (to study)" do
          conjugator = described_class.new("勉強する")
          expect(conjugator.conjugate).to eq("勉強します")
          expect(conjugator.conjugate(negative: true)).to eq("勉強しません")
        end
      end

      describe "くる/来る verbs" do
        it "conjugates くる (to come)" do
          conjugator = described_class.new("くる")
          expect(conjugator.conjugate).to eq("きます")
          expect(conjugator.conjugate(negative: true)).to eq("きません")
        end

        it "conjugates 来る (to come)" do
          conjugator = described_class.new("来る")
          expect(conjugator.conjugate).to eq("来ます")
          expect(conjugator.conjugate(negative: true)).to eq("来ません")
        end
      end

      describe "ある verbs" do
        it "conjugates ある (to exist)" do
          conjugator = described_class.new("ある")
          expect(conjugator.conjugate).to eq("あります")
          expect(conjugator.conjugate(negative: true)).to eq("ありません")
        end

        it "conjugates 有る (to exist)" do
          conjugator = described_class.new("有る")
          expect(conjugator.conjugate).to eq("有ります")
          expect(conjugator.conjugate(negative: true)).to eq("有りません")
        end
      end
    end

    # Verbal nouns that can be conjugated with する
    describe "suru verbs (verbal nouns)" do
      it "conjugates 愛用 (to regularly use)" do
        conjugator = described_class.new("愛用")
        expect(conjugator.conjugate).to eq("愛用します")
        expect(conjugator.conjugate(negative: true)).to eq("愛用しません")
      end

      it "conjugates 改正 (to revise)" do
        conjugator = described_class.new("改正")
        expect(conjugator.conjugate).to eq("改正します")
        expect(conjugator.conjugate(negative: true)).to eq("改正しません")
      end

      it "conjugates 完了 (to complete)" do
        conjugator = described_class.new("完了")
        expect(conjugator.conjugate).to eq("完了します")
        expect(conjugator.conjugate(negative: true)).to eq("完了しません")
      end

      it "conjugates 存在 (to exist)" do
        conjugator = described_class.new("存在")
        expect(conjugator.conjugate).to eq("存在します")
        expect(conjugator.conjugate(negative: true)).to eq("存在しません")
      end

      it "conjugates 理解 (to understand)" do
        conjugator = described_class.new("理解")
        expect(conjugator.conjugate).to eq("理解します")
        expect(conjugator.conjugate(negative: true)).to eq("理解しません")
      end
    end

    # Test handling of invalid inputs
    describe "invalid inputs" do
      describe "non-verb inputs" do
        it "returns わたし unchanged" do
          conjugator = described_class.new("わたし")
          expect(conjugator.conjugate).to eq("わたし")
          expect(conjugator.conjugate(negative: true)).to eq("わたし")
        end

        it "returns けっこう unchanged" do
          conjugator = described_class.new("けっこう")
          expect(conjugator.conjugate).to eq("けっこう")
          expect(conjugator.conjugate(negative: true)).to eq("けっこう")
        end
      end

      describe "empty inputs" do
        it "handles empty string" do
          conjugator = described_class.new("")
          expect(conjugator.conjugate).to eq("")
          expect(conjugator.conjugate(negative: true)).to eq("")
        end

        it "handles nil" do
          conjugator = described_class.new(nil)
          expect(conjugator.conjugate).to eq("")
          expect(conjugator.conjugate(negative: true)).to eq("")
        end
      end
    end
  end
end

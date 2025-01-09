RSpec.describe Kanjika::Conjugator::Masu do
  describe ".conjugate" do
    context "godan verbs" do
      context "う ending" do
        it { expect(described_class.conjugate("会う")).to eq("会います") }
        it { expect(described_class.conjugate("使う")).to eq("使います") }
        it { expect(described_class.conjugate("買う")).to eq("買います") }
      end

      context "く ending" do
        it { expect(described_class.conjugate("書く")).to eq("書きます") }
        it { expect(described_class.conjugate("歩く")).to eq("歩きます") }
      end

      context "ぐ ending" do
        it { expect(described_class.conjugate("泳ぐ")).to eq("泳ぎます") }
        it { expect(described_class.conjugate("急ぐ")).to eq("急ぎます") }
      end

      context "す ending" do
        it { expect(described_class.conjugate("話す")).to eq("話します") }
        it { expect(described_class.conjugate("押す")).to eq("押します") }
      end

      context "つ ending" do
        it { expect(described_class.conjugate("持つ")).to eq("持ちます") }
        it { expect(described_class.conjugate("待つ")).to eq("待ちます") }
      end

      context "ぬ ending" do
        it { expect(described_class.conjugate("死ぬ")).to eq("死にます") }
      end

      context "ぶ ending" do
        it { expect(described_class.conjugate("飛ぶ")).to eq("飛びます") }
        it { expect(described_class.conjugate("遊ぶ")).to eq("遊びます") }
      end

      context "む ending" do
        it { expect(described_class.conjugate("読む")).to eq("読みます") }
        it { expect(described_class.conjugate("飲む")).to eq("飲みます") }
      end

      context "る ending (godan)" do
        it { expect(described_class.conjugate("切る")).to eq("切ります") }
        it { expect(described_class.conjugate("走る")).to eq("走ります") }
      end
    end

    context "ichidan verbs" do
      context "with kanji" do
        it { expect(described_class.conjugate("食べる")).to eq("食べます") }
        it { expect(described_class.conjugate("見る")).to eq("見ます") }
        it { expect(described_class.conjugate("着る")).to eq("着ます") }
        it { expect(described_class.conjugate("寝る")).to eq("寝ます") }
      end

      context "without kanji" do
        it { expect(described_class.conjugate("たべる")).to eq("たべます") }
        it { expect(described_class.conjugate("みる")).to eq("みます") }
        it { expect(described_class.conjugate("おきる")).to eq("おきます") }
      end
    end

    context "irregular verbs" do
      context "する" do
        it { expect(described_class.conjugate("する")).to eq("します") }
        it { expect(described_class.conjugate("勉強する")).to eq("勉強します") }
      end

      context "くる/来る" do
        it { expect(described_class.conjugate("くる")).to eq("きます") }
        it { expect(described_class.conjugate("来る")).to eq("来ます") }
      end

      context "ある" do
        it { expect(described_class.conjugate("ある")).to eq("あります") }
        it { expect(described_class.conjugate("有る")).to eq("有ります") }
      end
    end

    context "suru verbs (verbal nouns)" do
      let(:suru_verbs) do
        {
          "愛用" => "愛用します",    # love and use
          "改正" => "改正します",    # revise
          "完了" => "完了します",    # complete
          "存在" => "存在します",    # exist
          "理解" => "理解します",    # understand
          "確認" => "確認します",    # confirm
          "実行" => "実行します",    # execute
          "勉強" => "勉強します",    # study
          "練習" => "練習します",    # practice
          "電話" => "電話します"     # call
        }
      end

      it "conjugates suru verbs correctly" do
        suru_verbs.each do |verb, expected|
          expect(described_class.conjugate(verb)).to eq(expected)
        end
      end
    end

    context "invalid inputs" do
      context "when input is not a verb" do
        it { expect(described_class.conjugate("わたし")).to eq("わたし") }  # I
        it { expect(described_class.conjugate("けっこう")).to eq("けっこう") } # fine/good
        # it { expect(described_class.conjugate("きれい")).to eq("きれい") }  # beautiful
      end

      context "when input is empty" do
        it { expect(described_class.conjugate("")).to eq("") }
        it { expect(described_class.conjugate(nil)).to eq("") }
      end
    end
  end
end

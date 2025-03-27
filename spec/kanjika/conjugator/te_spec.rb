RSpec.describe Kanjika::Conjugator::Te do
  describe "#conjugate" do
    context "godan verbs" do
      context "う ending verbs" do
        it "conjugates 会う - あう (to meet)" do
          conjugator = described_class.new("会う")
          expect(conjugator.conjugate).to eq("会って")
          expect(conjugator.conjugate(negative: true)).to eq("会わなくて")
        end

        it "conjugates 使う - つかう (to use)" do
          conjugator = described_class.new("使う")
          expect(conjugator.conjugate).to eq("使って")
          expect(conjugator.conjugate(negative: true)).to eq("使わなくて")
        end

        it "conjugates 買う - かう (to buy)" do
          conjugator = described_class.new("買う")
          expect(conjugator.conjugate).to eq("買って")
          expect(conjugator.conjugate(negative: true)).to eq("買わなくて")
        end
      end

      context "く ending verbs" do
        it "conjugates 書く - かく (to write)" do
          conjugator = described_class.new("書く")
          expect(conjugator.conjugate).to eq("書いて")
          expect(conjugator.conjugate(negative: true)).to eq("書かなくて")
        end

        it "conjugates 歩く - あるく (to walk)" do
          conjugator = described_class.new("歩く")
          expect(conjugator.conjugate).to eq("歩いて")
          expect(conjugator.conjugate(negative: true)).to eq("歩かなくて")
        end
      end

      context "ぐ ending verbs" do
        it "conjugates 泳ぐ - およぐ (to swim)" do
          conjugator = described_class.new("泳ぐ")
          expect(conjugator.conjugate).to eq("泳いで")
          expect(conjugator.conjugate(negative: true)).to eq("泳がなくて")
        end

        it "conjugates 急ぐ - いそぐ (to hurry, to rush)" do
          conjugator = described_class.new("急ぐ")
          expect(conjugator.conjugate).to eq("急いで")
          expect(conjugator.conjugate(negative: true)).to eq("急がなくて")
        end
      end

      context "す ending verbs" do
        it "conjugates 話す - はなす (to speak)" do
          conjugator = described_class.new("話す")
          expect(conjugator.conjugate).to eq("話して")
          expect(conjugator.conjugate(negative: true)).to eq("話さなくて")
        end
      end

      context "つ ending verbs" do
        it "conjugates 持つ - もつ (to hold)" do
          conjugator = described_class.new("持つ") # motsu
          expect(conjugator.conjugate).to eq("持って") # motte
          expect(conjugator.conjugate(negative: true)).to eq("持たなくて") # motanakute
        end
      end

      context "ぬ ending verbs" do
        it "conjugates 死ぬ - しぬ (to die)" do
          conjugator = described_class.new("死ぬ")
          expect(conjugator.conjugate).to eq("死んで")
          expect(conjugator.conjugate(negative: true)).to eq("死ななくて")
        end
      end

      context "ぶ ending verbs" do
        it "conjugates 遊ぶ - あそぶ (to play)" do
          conjugator = described_class.new("遊ぶ")
          expect(conjugator.conjugate).to eq("遊んで")
          expect(conjugator.conjugate(negative: true)).to eq("遊ばなくて")
        end

        it "conjugates 呼ぶ - よぶ (to call)" do
          conjugator = described_class.new("呼ぶ")
          expect(conjugator.conjugate).to eq("呼んで")
          expect(conjugator.conjugate(negative: true)).to eq("呼ばなくて")
        end

        it "conjugates 飛ぶ - とぶ (to fly)" do # 飛ぶ
          conjugator = described_class.new("飛ぶ")
          expect(conjugator.conjugate).to eq("飛んで")
          expect(conjugator.conjugate(negative: true)).to eq("飛ばなくて")
        end
      end

      context "む ending verbs" do
        it "conjugates 読む - よむ (to read)" do
          conjugator = described_class.new("読む")
          expect(conjugator.conjugate).to eq("読んで")
          expect(conjugator.conjugate(negative: true)).to eq("読まなくて")
        end
      end

      context "る ending verbs" do
        it "conjugates 帰る - かえる (to return)" do
          conjugator = described_class.new("帰る")
          expect(conjugator.conjugate).to eq("帰って")
          expect(conjugator.conjugate(negative: true)).to eq("帰らなくて")
        end

        it "conjugates 走る - はしる (to run)" do
          conjugator = described_class.new("走る")
          expect(conjugator.conjugate).to eq("走って")
          expect(conjugator.conjugate(negative: true)).to eq("走らなくて")
        end
      end
    end
  end

  describe ".conjugate" do
    context "godan verbs" do
      context "う-row endings" do
        {
          "有る" => "有って",   # る ending
          "読む" => "読んで"   # む ending
        }.each do |verb, expected|
          it "conjugates #{verb} to #{expected}" do
            expect(described_class.conjugate(verb)).to eq(expected)
          end
        end
      end
    end

    context "ichidan verbs" do
      {
        "食べる" => "食べて",   # Common ichidan
        "見る" => "見て",      # Kanji ichidan
        "いる" => "いて",      # Hiragana only
        "着る" => "着て"       # Kanji with same pronunciation as みる
      }.each do |verb, expected|
        it "conjugates #{verb} to #{expected}" do
          expect(described_class.conjugate(verb)).to eq(expected)
        end
      end
    end

    context "irregular verbs" do
      {
        "する" => "して",      # Basic する
        "くる" => "きて",      # Hiragana くる
        "来る" => "来て"       # Kanji くる
      }.each do |verb, expected|
        it "conjugates #{verb} to #{expected}" do
          expect(described_class.conjugate(verb)).to eq(expected)
        end
      end
    end

    context "suru verbs (verbal nouns)" do
      {
        "勉強" => "勉強して",    # Study
        "電話" => "電話して",    # Phone call (new case)
        "確認" => "確認して",    # Confirmation
        "存在" => "存在して"     # Existence
      }.each do |verb, expected|
        it "conjugates #{verb} to #{expected}" do
          expect(described_class.conjugate(verb)).to eq(expected)
        end
      end
    end

    context "invalid cases" do
      [
        "断然",      # Adverb
        "わたし",    # Regular noun
        "きれい",    # な-adjective (new case)
        "かわいい",  # い-adjective (new case)
        "あ"         # Single character (new case)
      ].each do |invalid_verb|
        it "returns 'invalid verb' for #{invalid_verb}" do
          expect(described_class.conjugate(invalid_verb)).to eq("invalid verb")
        end
      end
    end
  end
end

RSpec.describe Kanjika::Conjugator::Te do
  describe ".conjugate" do
    context "godan verbs" do
      context "う-row endings" do
        {
          "会う" => "会って",    # う ending
          "持つ" => "持って",   # つ ending
          "有る" => "有って",   # る ending
          "死ぬ" => "死んで",   # ぬ ending
          "飛ぶ" => "飛んで",   # ぶ ending
          "読む" => "読んで",   # む ending
          "書く" => "書いて",   # く ending
          "泳ぐ" => "泳いで",   # ぐ ending
          "話す" => "話して"    # す ending
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

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## System Requirement

MeCab must be installed on the host — all morphological analysis routes through the `ve` gem, which calls MeCab under the hood. Tests and any IRB session fail without it.

```bash
# Ubuntu/Debian
sudo apt-get install mecab libmecab-dev mecab-ipadic-utf8

# macOS
brew install mecab mecab-ipadic
```

## Commands

```bash
bundle exec rspec                          # run all tests
bundle exec rspec spec/path/to/file_spec.rb  # run a single spec file
bundle exec rake standard                  # lint (StandardRB with auto-fix)
bundle exec rake                           # default: spec + standard
```

CI matrix runs Ruby 3.1, 3.2, and 3.3. Development pin is 3.3.6 (managed via `mise`).

## Architecture

```
Kanjika.conjugate(verb, :masu, negative: false)
  └─ Verb#conjugate(:masu)
       └─ "Kanjika::Conjugator::Masu".constantize.new(verb).conjugate(negative:)
```

**`Kanjika::Verb`** (`lib/kanjika/verb.rb`) — thin wrapper. Resolves the conjugator class dynamically via `ActiveSupport#camelize` + `constantize`. Adding a new form means creating a new `Conjugator::<Form>` subclass; no dispatch table to update.

**`Kanjika::Conjugator::Base`** (`lib/kanjika/conjugator/base.rb`) — all conjugators inherit from here. Key responsibilities:
- Calls `Ve.in(:ja).words(verb)` to tokenize and identify inflection types.
- Exposes `group` (`:ichidan`, `:godan`, `:suru`, `:irregular`) and `stem` for subclasses.
- Holds character-set constants (`U_ENDINGS`, `I_ENDINGS`, etc.) used in kana transformations.

**Conjugator subclasses** — each implements `conjugate(negative:)`:
- `Masu` — straightforward `stem + "ます"/"ません"`.
- `Te` — most complex; uses `GODAN_MAPPING` hash and has a hard-coded special case for 行く.
- `Potential` — character-maps godan endings U→E then appends "る".

**Concerns** (defined but not yet mixed into Masu/Te/Potential — intended for future forms):
- `Concerns::VerbTypeDetector` — per-token type helpers (`ichidan?`, `godan?`, `irregular?`).
- `Concerns::TokenConjugator` — Template Method pattern; requires subclasses to implement `conjugate_ichidan`, `conjugate_godan`, `conjugate_irregular`, `conjugate_others`.

**Errors** (`lib/kanjika/errors.rb`) — `Kanjika::Error` (base) and `Kanjika::InvalidVerbError`.

## Adding a New Conjugation Form

1. Create `lib/kanjika/conjugator/<form>.rb` with `class Kanjika::Conjugator::<Form> < Base`.
2. Implement `conjugate(negative: false)` using `group`, `stem`, and the kana constants from `Base`.
3. `require_relative` it in `lib/kanjika.rb`.
4. Mirror the spec structure under `spec/kanjika/conjugator/`.

No other files need to change — `Verb#conjugate` resolves the class by name at runtime.

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

```text
Kanjika.conjugate(verb, :masu, negative: false)
  └─ Verb#conjugate(:masu)
       └─ conjugators[:masu] → Kanjika::Conjugator::Masu.new(verb).conjugate(negative:)
```

**`Kanjika::Verb`** (`lib/kanjika/verb.rb`) — thin wrapper. Resolves the conjugator class through an explicit allow-list Hash (`Verb#conjugators`), **not** `constantize` — dynamic constant lookup from user input was removed as an RCE vector in `0a18156` (see `docs/adr/0002-replace-constantize-with-explicit-whitelist.md`; treat as binding). Unknown forms raise `RuntimeError` with `Unknown form <type>`.

**`Kanjika::Conjugator::Base`** (`lib/kanjika/conjugator/base.rb`) — all conjugators inherit from here. Key responsibilities:
- Calls `Ve.in(:ja).words(verb)` to tokenize and identify inflection types.
- Exposes `group` (`:ichidan`, `:godan`, `:suru`, `:irregular`) and `stem` for subclasses.
- Holds character-set constants (`U_ENDINGS`, `I_ENDINGS`, etc.) used in kana transformations.

**Conjugator subclasses** — each implements `conjugate(negative:)`:
- `Masu` — straightforward `stem + "ます"/"ません"`.
- `Te` — most complex; uses `GODAN_MAPPING` hash and has a hard-coded special case for 行く.
- `Potential` — character-maps godan endings U→E then appends "る".

`Concerns::VerbTypeDetector` and `Concerns::TokenConjugator` were removed as dead code in `0753c70` (see `docs/adr/0003-remove-dead-concern-modules.md`) — they were defined but never mixed into any conjugator. If a Template Method abstraction across conjugators is needed again, reintroduce it from git history rather than reviving the old modules as-is.

**Errors** (`lib/kanjika/errors.rb`) — `Kanjika::Error` (base) and `Kanjika::InvalidVerbError`.

## Adding a New Conjugation Form

1. Create `lib/kanjika/conjugator/<form>.rb` with `class Kanjika::Conjugator::<Form> < Base`.
2. Implement `conjugate(negative: false)` using `group`, `stem`, and the kana constants from `Base`.
3. `require_relative` it in `lib/kanjika.rb`.
4. Register the form in the `Verb#conjugators` allow-list Hash (`lib/kanjika/verb.rb`) — required since ADR 0002; do not reintroduce `constantize`.
5. Mirror the spec structure under `spec/kanjika/conjugator/`.

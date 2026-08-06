# Kanjika Roadmap

Kanjika currently ships three conjugation forms (masu, te, potential) with
positive/negative variants across godan, ichidan, and irregular verbs. This
document collects concrete ideas for where the gem could go next.

Everything below is a **proposal, not a commitment**. Nothing here is scheduled
or approved — each item awaits a maintainer decision before any implementation
starts. Accepted items should be turned into GitHub issues (and, where the
design is non-obvious, an ADR in `docs/adr/`) before code is written.

## Proposed features (for discussion)

- **Past tense (ta form)** — 食べた(たべた), 書いた(かいた), した. Structurally
  almost free: the ta form reuses the te form's sound changes (て→た, で→だ), so
  `Conjugator::Ta` could lean on the existing `GODAN_MAPPING` including the
  行く(いく) special case.

- **Tai form (desire)** — 食べたい(たべたい) / 食べたくない(たべたくない)
  ("want to eat"). Builds directly on the masu stem already exposed by
  `Conjugator::Base#stem`, and is one of the first forms learners ask for
  after masu.

- **Volitional form** — 食べよう(たべよう), 書こう(かこう), しよう ("let's /
  shall we"). Godan verbs need an u→o column mapping, which fits the existing
  `*_ENDINGS` character-set pattern in `Base`.

- **Imperative form** — 食べろ(たべろ), 書け(かけ), しろ. Completes the
  plain-form family; godan verbs map u→e (the `E_ENDINGS` set already exists
  for the potential form), ichidan verbs take ろ.

- **Passive form** — 食べられる(たべられる), 書かれる(かかれる). Already
  promised in the README roadmap. Needs a design decision on how to flag the
  godan a-column stem (shared with causative) and whether to note the
  potential/passive ambiguity for ichidan verbs (both 食べられる(たべられる)).

- **Causative form** — 食べさせる(たべさせる), 書かせる(かかせる), させる. Also
  promised in the README roadmap; pairs naturally with passive since both
  build on the same negative/a-column stem for godan verbs.

- **Adjective conjugation (i/na adjectives)** — 高い(たかい)→高くない(たかくない)
  →高かった(たかかった); 静か(しずか)→静かじゃない(しずかじゃない).
  Promised in the README roadmap, but a bigger design question than new verb
  forms: it likely needs an `Adjective` entry point parallel to `Verb` rather
  than new `Conjugator` subclasses, so an ADR is warranted first.

- **Input validation and richer errors** — `Kanjika.conjugate("abc", :masu)`
  currently returns garbage ("ます") instead of failing, and unknown forms
  raise a bare `RuntimeError`. Proposal: raise `Kanjika::InvalidVerbError`
  when Ve/MeCab finds no verb in the input, and introduce a
  `Kanjika::UnknownFormError` (a `Kanjika::Error` subclass) for unknown forms.
  Both change observable behavior, so this needs an explicit maintainer
  decision and a minor-version bump.

- **Furigana / kana reading alongside kanji output** — requested by a
  maintainer still building kanji fluency: every conjugated form should
  optionally expose its kana reading (e.g. 食べた(たべた)), not just the
  kanji string. `Ve.in(:ja).words(verb)` already surfaces a `:reading`
  attribute (katakana, sourced from MeCab's IPADIC dictionary) via the `ve`
  gem, so the raw pronunciation data is available — open design questions
  are the public API shape (e.g. a `furigana:` option on `conjugate` vs. a
  separate `Kanjika.reading(verb)` method) and converting the katakana
  reading to hiragana for furigana-style display.

## Documentation convention

Per maintainer request (see PR #37 review discussion), this repository now
follows a standing convention — documented in `CLAUDE.md` — of writing
furigana (a hiragana reading in parentheses) after kanji in prose and code
comments, e.g. 食べる(たべる). This roadmap and `README.md` have been updated
to follow it; extending it to the remaining docs and code comments is tracked
as ongoing documentation upkeep rather than a separate roadmap item.

## Explicitly out of scope until decided

New forms must follow the existing architecture: one `Conjugator::<Form>`
subclass per form, registered in the `Verb#conjugators` allow-list (see
ADR 0002 — no `constantize` dispatch), with specs mirrored under
`spec/kanjika/conjugator/`.

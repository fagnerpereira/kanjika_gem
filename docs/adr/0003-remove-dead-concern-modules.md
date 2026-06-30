# ADR 0003 — Remove Unused Concern Modules (TokenConjugator, VerbTypeDetector)

Date: 2026-06-29
Status: Accepted

## Context

Two modules lived in `lib/kanjika/conjugator/concerns/`:

- `Kanjika::Conjugator::Concerns::TokenConjugator` (58 lines)
- `Kanjika::Conjugator::Concerns::VerbTypeDetector` (28 lines)

A search of the codebase (`grep -r "TokenConjugator\|VerbTypeDetector" lib/ spec/`)
returns zero hits in any production file except their own definition files. Neither
module is `include`d by `Conjugator::Base`, `Conjugator::Masu`, `Conjugator::Te`, or
`Conjugator::Potential`. They exist only as code that is required at startup but never
called.

They were also introduced at a time when the architecture planned a MeCab-driven token
processing pipeline. That architecture was abandoned in favour of the current approach
(direct class dispatch from `Verb#conjugate`). The concerns represent the old design
that was never fully wired up and then superseded.

## The Lesson: Dead Code Is a Liability, Not an Asset

It is tempting to leave unused code in place "just in case" — maybe it will be useful
later, maybe it serves as documentation of a design that was tried. In practice, dead
code has real costs:

1. **Cognitive load**: Every file in `lib/` signals to a reader "this is important, it
   is loaded at startup." A reader tracing through `Kanjika.conjugate` finds the
   requires for `VerbTypeDetector` and `TokenConjugator` and wonders where they are
   used. They search, find nothing, and spend time confirming they are indeed unused.

2. **Maintenance surface**: Dead code receives no test coverage. If its dependencies
   change (e.g., a `Base` constant is renamed), the dead code silently breaks. When
   someone later tries to revive it, they discover it no longer compiles.

3. **Security exposure**: In this specific case, `TokenConjugator` references constants
   like `Base::ICHIDAN_TYPE` and `Base::GODAN_TYPE` and calls `apply_conjugation_rule`.
   If those constants or methods ever change, the dead module fails to load — causing
   a boot error in an entirely different place than the actual change. Dead code creates
   invisible coupling.

4. **Test noise**: The specs for these two modules (`token_conjugator_spec.rb` and
   `verb_type_detector_spec.rb`) test code that nothing uses. They add ~300 lines of
   spec that run on every CI push but provide zero protection against regressions in
   features that actually exist.

The Boy Scout Rule applies: leave the codebase cleaner than you found it. If code is
not used and has no near-term plan to be used, delete it. Version control (git) provides
an undo button — the code is not lost, it is in history. Use `git log -S "TokenConjugator"`
to find it again if it ever becomes relevant.

## Checklist Before Deleting Code

1. `grep -r "ClassName" lib/ app/ spec/` — confirm no usages.
2. Check if anything dynamically refers to it (e.g., `constantize` based dispatch,
   `autoload` registrations). In this repo: `lib/kanjika.rb` lists all requires
   explicitly, so a grep is conclusive.
3. Check git history — `git log --all -- path/to/file` — to understand when and why it
   was added. Understanding the past design helps avoid reintroducing the same thing.
4. Delete the production file, its spec, and the require line in the entry-point file.
5. Run the full test suite. If tests break, you missed a usage.

## Decision

Delete:
- `lib/kanjika/conjugator/concerns/token_conjugator.rb`
- `lib/kanjika/conjugator/concerns/verb_type_detector.rb`
- `spec/kanjika/conjugator/concerns/token_conjugator_spec.rb`
- `spec/kanjika/conjugator/concerns/verb_type_detector_spec.rb`

Remove the two `require_relative` lines that loaded these files from `lib/kanjika.rb`.

## Consequences

- `lib/kanjika/conjugator/concerns/` is now empty and can be removed when convenient.
- `bundle exec rake` no longer loads ~90 lines of dead production code at startup.
- The spec run is faster by ~300 lines of tests that were covering code nothing calls.
- New contributors reading `lib/kanjika.rb` see a clean, accurate list of what the
  library actually uses — no false leads.
- If the token-pipeline architecture is revisited, the files can be recovered from git
  history and reintroduced with proper wiring and tests.

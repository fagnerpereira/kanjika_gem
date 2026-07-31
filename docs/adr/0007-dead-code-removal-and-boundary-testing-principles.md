# ADR 0007 — Dead Code as Liability, and Why We Test the Boundary, Not the Middle

Date: 2026-07-30

Status: Accepted

## Context

This PR does two things to `Kanjika::Conjugator::Base` that look unrelated at
a glance but come from the same underlying discipline:

1. Deletes `#ending_in_e_or_i?` and `#irregular?` — two public predicate
   methods with zero callers anywhere in `lib/` or `spec/`.
2. Adds specs for `#process` and `#stem` when called with `nil` or `""`,
   asserting they short-circuit *before* ever touching `Ve.in(:ja).words`
   (the MeCab-backed tokenizer).

Both changes are small. The reasoning behind them is worth writing down
explicitly, because it generalizes far past this one class, and it's the
kind of judgment call a junior engineer will face constantly: "should I
delete this?" and "which inputs actually need a test?"

## Decision 1 — Delete code nothing calls (YAGNI as an ongoing practice, not a one-time filter)

**The principle:** every line of code you keep is a line someone has to
read, understand, and reason about correctness for — forever, or until it's
deleted. That cost is paid whether or not the code is ever executed. A
method with zero callers pays the full cost of existing (reviewers read it,
new hires ask "where is this used?", refactors have to preserve its
behavior "just in case," it shows up in `grep` and search results, it can
silently rot as the rest of the class changes around it) while returning
zero value, because nothing depends on it doing anything in particular.

This is YAGNI ("You Aren't Gonna Need It") applied *after* the fact, not
just before it. YAGNI is usually taught as "don't build speculative
features" — a discipline for writing code. It's just as important as a
discipline for *maintaining* code: when you find something that was built
speculatively (or was once used and no longer is) and confirm nothing
depends on it, the right move is to delete it, not to leave it alone out of
inertia or a vague sense that deleting code is riskier than leaving it.

**Why deletion is the safe choice here, not the risky one.** The instinct to
protect unused code ("what if we need it later?") gets the risk backwards
for anything under version control. Git remembers every line that was ever
written. Reviving `ending_in_e_or_i?` from history, if a future form
genuinely needs it, costs one `git log -p -- <path>` and a copy-paste — a
few minutes. Carrying it forward unused costs a little bit of attention
from every single person who reads the class between now and whenever it's
finally deleted, multiplied over however many months or years that is. The
asymmetry is the whole argument: cheap to resurrect, expensive to carry.

**How to verify "zero callers" before deleting**, so this isn't a guess:

- `grep -rn "method_name" lib/ spec/` (or your language's equivalent) across
  the whole codebase, not just the file you're looking at.
- Check it's not part of the class's *public contract* — i.e., not
  something documented as an API other gems/apps are expected to call. A
  private, unused helper inside a library's internals is very different
  from an unused *public* method on a class explicitly meant to be used
  externally; the latter needs a deprecation cycle, not a silent delete.
  (`Base` here is an internal implementation detail of the conjugator
  hierarchy, not part of `Kanjika`'s public API — see `lib/kanjika/verb.rb`
  for what's actually exposed.)
- Check recent history and open work (PRs, issues, TODOs) for signals that
  it's about to be wired up. Code that's unused *today* but has a concrete,
  near-term plan behind it is a different case from code that's simply
  never been called and nothing points at it — this repo's own history
  (ADR 0004) has an example of two PRs disagreeing about exactly this
  distinction for the same method.

None of that changes the conclusion here — `ending_in_e_or_i?` and
`irregular?` had no callers, no documented external contract, and no
recorded plan — but the checklist matters more than the specific example,
because you'll run it again on code that isn't this code.

## Decision 2 — Test the seams, not the interior

**The principle:** a library's public API has a boundary — the set of
entry points callers actually invoke — and an interior — the private
machinery behind it. Boundary inputs deserve deliberate, explicit test
coverage for edge cases (`nil`, `""`, unexpected types, extreme sizes)
*precisely because the caller is out of your control*. Anyone, including
future-you, can call `Verb.new(nil).conjugate(:masu)` without reading the
implementation first. The interior doesn't have that problem — internal
methods are only ever called by code you also control and can audit
directly, so their edge-case behavior is usually adequately pinned down by
the boundary tests exercising them indirectly.

For a **text-processing library** specifically, this matters more than in
most domains, for two concrete reasons:

1. **The inputs are free-form user/document text**, which means `nil` and
   `""` aren't hypothetical — they're what you get from an empty form
   field, a missing dictionary lookup, a trimmed string that turned out to
   be all whitespace, or a batch job iterating over a CSV column with gaps.
   These aren't exotic adversarial inputs; they're the ordinary shape of
   real data.
2. **The failure mode when you get it wrong is expensive, not just wrong.**
   `Base#process` calls out to `Ve.in(:ja).words(verb)`, which shells out to
   a MeCab subprocess. If the nil/empty guard clause were ever accidentally
   removed or bypassed, the failure wouldn't be a clean, fast exception at
   the Ruby boundary — it would be a slow, possibly-confusing failure deep
   inside a subprocess call, or (worse) MeCab silently tokenizing garbage
   and returning something plausible-looking but wrong. A boundary test
   that fails fast and close to the mistake is far more valuable than
   whatever would happen several layers down without one.

**Why "assert the return value" alone isn't enough — assert the *path*
taken.** The specs added here don't just check
`conjugator.process(nil) == []`; they also assert `expect(Ve).not_to
receive(:in)`. This distinction is the difference between testing an
outcome and testing a guarantee. `process == []` is also what you'd see if
`Ve.in` were called, returned something, and the result got mapped down to
an empty array by accident — the test would pass for the wrong reason, and
a regression that started hitting MeCab on empty input would sail through
CI undetected (it would just be slower and, in an environment without
MeCab installed, would fail with an unrelated-looking error instead of the
intended guard clause). Asserting the collaborator is never invoked pins
down *why* the output is `[]`, not just *that* it is — which is exactly the
guarantee a "don't call the expensive/fragile dependency on bad input"
guard clause is supposed to provide.

**The general rule of thumb:** when you're deciding whether an edge case
needs its own test, ask "can something other than my own reviewed code
reach this input?" If the answer is yes — it's a public method, it's fed by
user input, it's fed by an external system, it's fed by another team's code
— test the edges deliberately. If the answer is no — it's a private helper
only called with values already validated one layer up — trust the
boundary tests to cover it, and don't multiply test cases that all exercise
the same guarantee from slightly different internal angles.

## Consequences

- `Base` no longer carries two untested, uncalled predicate methods; if a
  future conjugation form needs `ending_in_e_or_i?`-like logic, pull it
  back out of git history (`git log -p -- lib/kanjika/conjugator/base.rb`)
  rather than assuming today's version is still the right shape for a
  requirement we don't have yet.
- `Base#process` and `Base#stem` have explicit, fast, MeCab-independent
  regression coverage for `nil`/`""` input, including a guard against the
  "return value looks right but the guard clause was silently bypassed"
  failure mode.
- The general principles above — delete confirmed-dead code rather than
  preserve it "just in case," and give deliberate edge-case coverage to a
  library's public boundary rather than spreading equivalent tests across
  its internals — are the lens to apply to future `Kanjika` changes, not
  just this diff.

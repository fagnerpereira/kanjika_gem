# ADR 0004 — Remove Dead `Base` Predicates; Consolidate Four Overlapping Jules PRs

Date: 2026-07-01
Status: Accepted

## Context

Four draft PRs were opened automatically by Jules within a few hours of each
other, all touching `lib/kanjika/conjugator/base.rb` or its spec:

- **#17** — add tests + a length-guard bugfix for `Base#ending_in_e_or_i?`
- **#18** — delete `Base#ending_in_e_or_i?` and `Base#irregular?` as dead code
- **#19** — remove `Concerns::TokenConjugator` and `Concerns::VerbTypeDetector`
- **#20** — add nil/empty edge-case tests for `Base#process` and `Base#stem`

Each was scoped independently by an automated task runner that did not know
about the others, so their intents overlap and, in one case, directly
contradict each other.

## Decision 1: #18 over #17 (contradictory intent, same method)

#17 and #18 both target `Base#ending_in_e_or_i?`, but pull in opposite
directions: #17 assumes the method has a future and invests in testing +
fixing it (a `TypeError` on strings under 2 characters); #18 assumes it has
no future and deletes it outright. Both cannot be applied — keeping #17's
tests would immediately need updating once #18's deletion landed, and vice
versa.

`grep -rn "ending_in_e_or_i?\|irregular?" lib/ spec/` at the time of review
showed zero callers anywhere outside each method's own definition. Nothing in
`CLAUDE.md`, git history, or any open PR signalled near-term plans to wire
either method up. This is the same dead-code calculus as ADR 0003: unused
code is a liability (cognitive load, untested surface, invisible coupling),
and reviving it from git history later is cheap if a real need appears.
Testing or bug-fixing a method nothing calls does not change that calculus —
it just makes the liability harder to delete later, since now there are
tests to lose too.

**Decision:** take #18 (delete `ending_in_e_or_i?` and `irregular?`). Close
#17 with this reasoning attached.

## Decision 2: #19 is redundant, not wrong

#19 proposed removing `Concerns::TokenConjugator` and
`Concerns::VerbTypeDetector` — the exact same modules, spec files, and
`require_relative` lines already deleted straight to `main` in `0753c70`
("chore: remove dead TokenConjugator and VerbTypeDetector modules", see ADR
0003), one day before Jules opened #19 against an older base commit. The
`CLAUDE.md` snapshot #19's task runner read from was stale — it still
described those Concerns as present, which is what made the removal look
like new work. It was not: `main` had already moved past it.

**Decision:** close #19 as redundant against current `main`. No code from it
is folded in, because there is nothing left to fold — the change is already
shipped. `CLAUDE.md`'s "Concerns" section is refreshed in this PR to stop
describing the modules as present, closing the loop that made #19 look
necessary in the first place.

## Decision 3: #20 folds in cleanly

#20's tests (nil/empty verb input to `#process` and `#stem`, asserting both
return early instead of reaching the MeCab-backed `Ve.in(:ja).words` call)
have no conflict with #18's deletion — different methods, additive only.
Verified the underlying claim before folding in: `Base#process` and
`Base#stem` both short-circuit (`[]` / `nil`) for `nil`/`""` input without
touching `Ve`. Adapted, not applied verbatim: the spec file's structure had
changed since #20 was opened (no `#process` describe block existed yet, and
`#stem` already had its own block with a `:needs_mecab` tag), so the new
contexts were nested into the current structure rather than pasted as new
top-level blocks.

Follow-up review feedback (gemini-code-assist) on the resulting PR (#27)
pointed out that asserting only the return value doesn't prove the
short-circuit actually happened — a test asserting `conjugator.process == []`
passes whether or not `Ve.in` was called internally and simply discarded.
Fixed by adding `expect(Ve).not_to receive(:in)` in each nil/empty context, so
the test fails loudly if the guard clause is ever removed and the code starts
hitting MeCab on empty input.

**Decision:** close #20 in favor of the folded-in version in #27.

## Consequences

- One PR (#27) supersedes four; #17, #18, #19, #20 are closed with the
  reasoning above, and their now-orphaned branches are deleted since none of
  them is a base for any other branch or PR.
- `Base` no longer carries two untested, uncalled predicate methods.
- `Base#process` / `Base#stem` have explicit regression coverage for
  nil/empty input, including a guard against the "return value looks right
  but internally still called the expensive dependency" failure mode.
- `CLAUDE.md` reflects `main` as it actually is, removing the staleness that
  produced the redundant #19 in the first place.
- Future automated task runners (Jules or otherwise) should be pointed at a
  fresh `main` before scoping cleanup tasks, to avoid re-discovering work
  that already shipped.

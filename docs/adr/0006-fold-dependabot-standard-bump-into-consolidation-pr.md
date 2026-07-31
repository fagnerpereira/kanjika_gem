# ADR 0006 — Fold the Dependabot `standard` 1.55→1.56 Bump into #30 Instead of Merging It Separately

Date: 2026-07-20
Status: Accepted

## Context

Dependabot opened PR #31, a routine dev-dependency bump: `standard` `~> 1.55`
→ `~> 1.56` (which pulls `rubocop` `1.87.0` → `1.88.2` as a transitive
dependency — `standard` vendors a pinned rubocop range, so a `standard` bump
is really a `rubocop` bump wearing a friendlier name). At the same time, #30
was open as a draft, consolidating the earlier #17/#18/#19/#20/#27 cleanup
work (see ADR 0004) plus a rescue-narrowing fix (ADR 0005). Both PRs targeted
`main` at the same commit (`c3e6c93`), so neither was blocked on the other —
they could have been merged independently in either order.

This ADR is for a junior engineer asking "why not just merge the Dependabot
PR on its own, the way Dependabot PRs normally get merged?"

## Why fold it in rather than merge #31 separately

**1. A linter/tooling version bump is not exempt from CI — it can *break* CI.**

`standard` and `rubocop` release new cops (style/lint rules) in minor
versions, not just major ones. A minor bump can start failing a build that
was previously green, purely because code that was fine under the old rule
set now trips a newly-enabled cop. That means a "trivial" dependency bump
PR needs the exact same verification as a real code change: run the linter
*after* the bump and read the diff in offenses, not just the diff in
`Gemfile.lock`. Merging it on Dependabot's auto-merge path (or rubber-stamping
it) without that check is how a repo wakes up to a red `main`.

**2. #30 was already mid-flight through that exact verification loop.**

#30's whole job in this session was "make sure `bundle exec rspec` and
`bundle exec rake standard` are actually green, with real dependencies
installed" (see #30's body: the previous session couldn't install MeCab and
had to reason about a stale baseline). Since the standard bump has to go
through that same verification step regardless of which PR it rides in on,
attaching it to #30 means it gets verified once, in the same CI run, instead
of opening a second review/CI cycle that re-does the identical
`bundle install` → `rspec` → `rake standard` dance.

**3. Merge-order interaction.** If #31 had merged into `main` first and #30
second, #30 would need a rebase to pick up the new `Gemfile.lock` anyway (or
CI would run against a `Gemfile.lock` that #30's branch didn't have,
producing a confusing mismatch between "what #30's diff shows" and "what CI
actually ran"). Committing the bump directly onto #30's branch sidesteps that
rebase-after-merge shuffle entirely — one branch, one linear history, one CI
run that reflects exactly what's in the diff.

**4. Low cost, because the two changes don't overlap.** #30 touches
`lib/kanjika/conjugator/base.rb`, `lib/kanjika/ve_patch.rb`, specs, and docs.
#31 touches only `Gemfile` and `Gemfile.lock`. Cherry-picking Dependabot's
commit (`ca83c8a`) onto #30's branch applied without any conflict — there was
nothing to reconcile, which is exactly the situation where folding two PRs
together is cheap and safe (compare to ADR 0004's Decision 1, where two PRs
touched the *same* method with *contradictory* intent and could not both be
applied).

This is not a blanket rule that dependency bumps always get folded into
whatever consolidation PR happens to be open — if #30 had been mid-review
with change requests pending, or if the bump had conflicted with #30's
changes, the right call would have been to let #31 merge on its own. The
fold-in is justified here specifically because verification was already
required, already in progress, and the diffs were disjoint.

## What we checked before folding it in (and what we'd have done differently)

Cherry-picked `ca83c8a` onto `claude/charming-cray-vcicrc` (#30's branch),
then re-ran `bundle install`, `bundle exec rake standard`, and
`bundle exec rspec` with MeCab actually installed in this session (a genuine
improvement over the prior session's MeCab-less baseline — see #30's own
body for that caveat). Result: **zero new `standardrb`/`rubocop` offenses**,
and **87 examples, 0 failures, 0 pending** — the codebase happened to already
be clean under rubocop 1.88's newly-enabled cops.

That "happened to be clean" result is itself the lesson worth drawing out,
not just the mechanical step of running the linter:

- **Floating dev-dependency version constraints (`~> 1.55`, matching any
  `1.55.x`... but Dependabot bumps the *pinned* lockfile version, e.g. to
  `1.56.0`) mean your lint rules can change out from under you without
  anyone touching application code.** That's normally fine for pure
  dev-tooling (a linter isn't a runtime dependency; it can't introduce a
  production regression) — but it does mean "no changes to `lib/`" is not
  the same guarantee as "CI will stay green." A linter bump is a distinct
  risk category from a runtime dependency bump: it can only ever cause a
  *build/CI* failure, never a production one, but that still means someone
  has to look at it before merging, not just trust the green Dependabot
  compatibility badge.
- **If this bump *had* surfaced a new offense**, the correct response would
  still have been to fix the offense in this same PR (small, mechanical,
  auto-fixable in the common case via `bundle exec rake standard:fix`) rather
  than pinning the old version to dodge it — pinning just defers the same
  cleanup to whenever someone eventually does bump it, with more code
  having drifted from the new style rule by then. Floating + fix-on-bump
  keeps the drift small and continuous; pinning + big-bang-upgrade-later
  trades a series of small diffs for one large, harder-to-review one.
- Conversely, this is also the argument *for* keeping bumps like this
  isolated to their own commit (as done here — `a2e4f28` is a standalone
  commit on top of #30's other commits, not squashed into them): if it *had*
  needed a style fix, that fix would be attributable to "the tooling bump
  made me do this," not muddled together with #30's actual behavioral
  changes in the same commit.

## Consequences

- #31 is closed with a comment pointing here and at #30; its branch
  (`dependabot/bundler/standard-1.56.0`) is best-effort deleted since #30
  now carries the same change.
- #30 gains one additional commit (`a2e4f28`, cherry-picked verbatim from
  Dependabot's `ca83c8a`) bumping `standard` to `1.56.0` (and transitively
  `rubocop` to `1.88.2`), on top of its existing five commits.
- `bundle exec rspec` (87 examples, 0 failures, MeCab installed) and
  `bundle exec rake standard` (no offenses) both stay green after the bump.
- Future Dependabot PRs for **dev-only** tooling (linters, test runners) that
  land while a consolidation/cleanup PR is already open and unmerged should
  be evaluated for folding in under this same reasoning: check for
  conflicts, check for newly-enabled-cop fallout, and only merge separately
  if either check fails or the consolidation PR is far enough into review
  that adding a commit would be disruptive. This does not apply to
  *runtime* dependency bumps, which carry production risk and deserve their
  own isolated PR and review regardless of what else is open.

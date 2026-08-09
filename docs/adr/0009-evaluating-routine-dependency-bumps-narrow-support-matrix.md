# ADR 0009 — Evaluating a Routine Dependency-Bump PR for a Library With a Narrow Support Matrix

Date: 2026-08-09

Status: Accepted

## Context

Dependabot opens a lot of PRs against this gem, and it's tempting to treat
them all the same way: green CI means merge, red CI means rebase or close.
That instinct is *mostly* right, but this repo's own history shows it isn't
sufficient on its own.

On 2026-08-03, PR #36 bumped `activesupport` 7.2.3.1 → 7.2.3.2. CI was fully
green — all three Ruby versions in the matrix (3.1, 3.2, 3.3) plus
GitGuardian passed. It was merged the same way any green dependabot PR gets
merged. Less than five hours later, the maintainer opened and merged PR #38,
reverting it, with the commit message simply reading `Revert
"chore(deps): bump activesupport from 7.2.3.1 to 7.2.3.2"` — no comment on
either PR, no CHANGELOG entry, no ADR explaining what went wrong.

This ADR was written while triaging PR #39 (`json` 2.21.1 → 2.21.2), a
similarly "routine-looking" green dependabot PR, using the #36/#38 episode as
the worked example. The point isn't "the activesupport bump was bad, avoid
it" — there isn't enough evidence in the repo to say that with confidence.
The point is what a green CI matrix does and doesn't tell you, and what to
check *in addition to it* before waving a bump through — especially for a
gem like this one, whose supported Ruby matrix (3.1/3.2/3.3, per `CLAUDE.md`)
and MeCab system dependency make its compatibility surface unusually narrow
and easy to break in ways generic CI won't catch.

## Decision: a routine dependency bump gets four checks, not one

**1. CI green is necessary, not sufficient — say so explicitly when you rely on it.**

A passing test suite tells you the code you tested still does what the tests
assert. It says nothing about:

- Behavior the test suite doesn't exercise (this gem's coverage is high but
  not 100%, and any suite has blind spots by construction).
- Runtime environments CI doesn't reproduce (a maintainer's local machine,
  downstream consumers of the gem, Ruby patch versions outside the matrix).
- Non-functional concerns tests aren't written to catch (memory behavior,
  timing, warnings on `stderr` that don't fail a test but would look wrong
  in a REPL).

PR #36 is the concrete proof: 3/3 Ruby versions green, GitGuardian green,
merged, reverted anyway. **Whatever motivated the revert, it wasn't visible
in CI.** So "CI is green" is a fact to report, not a conclusion to hide
behind. Say it plainly ("CI is green, *and here is what else I checked*")
rather than letting a green checkmark stand in for a full review.

**2. Read the changelog for what actually changed, not just the version delta.**

A version bump from `2.21.1` to `2.21.2` looks identical in shape to
`7.2.3.1` to `7.2.3.2` — both patch releases, both "safe" by semver
convention. They are not equivalent bumps once you read *why* each was cut:

- `json` 2.21.2's changelog has exactly one line: a fix for a use-after-free
  bug in `JSON::ResumableParser` (GHSA-9hj4-r449-hfvc), a security-relevant
  bugfix with a named CVE-class vulnerability and a narrow, named code path.
- `activesupport` 7.2.3.2's changelog says "No changes" for every subsystem
  except Active Storage (disabling untrusted libvips loaders by default —
  unrelated to anything this gem touches). A bump with essentially no
  functional content on paper is *harder* to reason about after the fact,
  not easier, because there's no documented change to point to as either
  "obviously fine" or "obviously the culprit."

The lesson: don't infer risk from the version number shape (patch vs. minor
vs. major). Read the actual changelog entry and ask whether it plausibly
touches anything this gem depends on.

**3. Check the full diff, not just the named dependency — transitive movement hides in `Gemfile.lock`.**

This is the most concrete, checkable difference between the two PRs. Diff
`Gemfile.lock` for both:

- PR #39 (`json`): one line changed. `json (2.21.1)` → `json (2.21.2)`.
  Nothing else moved.
- PR #36 (`activesupport`): **two** lines changed. `activesupport` itself,
  *and* `concurrent-ruby (1.3.7)` → `concurrent-ruby (1.3.8)` — a transitive
  dependency that rode along with the bump and was never mentioned in
  `activesupport`'s own release notes, because it isn't activesupport's
  changelog to write.

A single-line lockfile diff has exactly one plausible source of behavior
change. A multi-line diff has as many plausible sources as it has changed
lines, and the top-level changelog you're reading (the named dependency's)
won't tell you what changed in the dependencies that came along for the
ride. Always read the full `git diff` / PR diff on `Gemfile.lock`, not just
the PR title's dependency name — dependabot's own PR title only advertises
the direct bump it was targeting, not what else moved underneath it.

**4. Cross-reference recent revert history before merging, and treat an undocumented revert as a gap to flag, not a mystery to silently solve.**

Before treating any dependabot PR as routine, check
`list_pull_requests(state=closed)` for recent `Revert "..."` titles. If one
exists near in time to the dependency family you're reviewing, that's a
strong signal to look closer — but "look closer" can legitimately conclude
"I found no documented reason, and CI was green then too." That's still a
useful thing to report:

- It tells the next reviewer (human or agent) that a green matrix isn't a
  clean bill of health for this class of dependency, which is worth
  knowing independent of whether *this specific* PR is safe.
- It's honest about the limits of what's checkable after the fact. Don't
  invent a plausible-sounding root cause for #36's revert that the evidence
  doesn't support — "no changes" in a Rails patch release plus an unlogged
  transitive `concurrent-ruby` bump is a *plausible* culprit, not a
  confirmed one, and the write-up should say so at that confidence level.

## Consequences

- When reviewing a dependabot PR for this gem, the standing checklist is:
  (a) confirm CI status honestly instead of treating green as sufficient by
  itself, (b) read the changelog for the actual change, not just the
  version numbers, (c) diff the full lockfile for transitive movement the
  named dependency's changelog won't cover, (d) check recent closed PRs for
  reverts in the same dependency family and report what is and isn't
  documented about them.
- This doesn't mean every green dependabot PR needs an essay — most bumps
  (this `json` one included) turn out to be low-risk after a few minutes of
  this checklist. The point is doing the checklist deliberately rather than
  pattern-matching "dependabot + green CI = merge" on autopilot, because
  this repo has direct proof that pattern can fail silently.
- Going forward, reverts in this repo should ideally carry a one-line reason
  in the revert PR body or a CHANGELOG entry — not for process's sake, but
  because the absence of one is exactly what made this ADR's investigation
  inconclusive on the *original* cause, even though it was still possible to
  reach a confident, evidence-based decision on the *current* PR.

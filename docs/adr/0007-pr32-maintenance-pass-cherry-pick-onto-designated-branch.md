# ADR 0007 — Routine Maintenance Pass: Cherry-Pick #32 onto This Session's Branch

Date: 2026-07-24

Status: Accepted

## Context

This is a scheduled PR-maintenance session, the same recurring task that
produced #30 (ADR 0004/0005/0006) and #32. The prior session's #32 was
already a clean cherry-pick of #30's 8 commits onto a fresh session branch,
because `main` hadn't moved since #30 was verified. This session's job was
to re-verify that nothing changed in the meantime and, if not, repeat the
same mechanical step onto *this* session's designated branch
(`claude/charming-cray-pec4g1`).

This ADR exists mainly for a junior engineer wondering "didn't we already
write this ADR three times (0004 saying why, 0005/0006 saying what changed)?
Why does a pass that changes nothing need its own entry?" — see
Consequences below for why the answer is "yes, and that's the point."

Checked live before touching anything:

- `main` was still at `c3e6c93`, the exact SHA #32 was opened against and
  the exact SHA this session's branch already sat on. No drift to reconcile.
- #32's CI: all four checks (`test` on Ruby 3.1/3.2/3.3, GitGuardian) green.
- #32's review threads: zero open. The only comment on the PR is an
  automated `gemini-code-assist[bot]` notice that its own review service
  has been sunset — not feedback to act on, just noise to not mistake for a
  live review request.
- No new PRs, issues, or Dependabot activity had appeared since #32 opened
  (`list_pull_requests`, `list_issues` both confirmed via the GitHub API,
  not assumed from #32's body).
- #32's 8 commits, diffed commit-for-commit against what #32's body claims,
  matched exactly (same SHAs, same messages, same order).

Given all of that, there was nothing new to fold in — this pass is a pure
repeat of the mechanical step, not a design decision.

## Decision

Cherry-pick #32's 8 commits (`8473e9b` … `714baa0`), unchanged and in order,
onto `claude/charming-cray-pec4g1`. All 8 applied without conflict — expected,
since this branch and #32's source branch (`claude/charming-cray-zifohv`)
both fork from the same `c3e6c93` `main`, and #32's own commits are
themselves an unmodified replay of #30's.

Verified the result two ways, not one:

1. `git diff HEAD origin/claude/charming-cray-zifohv` — empty. The two
   branches are byte-identical after the cherry-pick, the same check #32's
   own body used to confirm its cherry-pick from #30.
2. Ran the actual test and lint suite locally, with MeCab genuinely
   installed this session (`sudo apt-get install -y mecab libmecab-dev
   mecab-ipadic-utf8`) — not inferred from #32's report of its own run.
   `bundle exec rspec`: **87 examples, 0 failures**. `bundle exec
   standardrb`: **0 offenses**. Both match the baseline #30 and #32 already
   established.

One environment wrinkle worth recording so the next session doesn't lose
time on it: `bundle exec rspec` and `bundle exec rake standard` initially
failed with `command not found`, even though `bundle install` reported
those gems present. The cause wasn't a missing gem — it was that this
sandbox's `PATH` doesn't include `/opt/rbenv/shims`, so the bare `ruby` on
`PATH` resolved to a system Ruby outside rbenv's control, and gem
executables built against rbenv's 3.3.6 weren't reachable from it. Running
`eval "$(rbenv init -)"` (which prepends the shims directory to `PATH`)
before `bundle exec` fixed it. This is a shell/session-init gap, not a
project or `Gemfile` problem — no repo file needed to change.

Opened a new PR from this branch, closed #32 pointing at it, and
best-effort deleted #32's source branch (`claude/charming-cray-zifohv`) plus
the older `claude/charming-cray-vcicrc` (#30's branch, already closed,
left undeleted by that session per its own ADR 0004/0006 notes about
branch cleanup being best-effort).

## Consequences

- The content shipped is identical to #30/#32: dead `Base` predicate
  removal (ADR 0004), narrowed `ve_patch.rb` rescues (ADR 0005), the
  `standard` 1.56.0 bump (ADR 0006), and the nil/empty edge-case specs —
  nothing new landed in this pass, by design.
- A maintenance session that finds nothing new to do is not a wasted
  session — it's the mechanism that keeps a long-lived draft PR from
  silently going stale while `main`, CI, or review state moves underneath
  it. The value here was in the *checking* (SHA, CI, threads, new PRs,
  issues, Dependabot), not in any code change; recording that the checks
  were actually run, and what they found, is what lets the next session
  trust "still nothing new" without re-deriving it from scratch.
- The `rbenv init` / `PATH` gotcha above is now written down so a future
  session that installs MeCab correctly but still sees `command not found`
  doesn't waste time suspecting the `Gemfile.lock` or gem install instead.
- If a future pass in this chain *does* find something new (a real review
  comment, a moved `main`, a fresh Dependabot PR), the precedent from ADR
  0004–0006 still applies: fold in what's small and non-conflicting,
  re-verify with the full suite, and write the reasoning down rather than
  silently absorbing it into a commit message alone.

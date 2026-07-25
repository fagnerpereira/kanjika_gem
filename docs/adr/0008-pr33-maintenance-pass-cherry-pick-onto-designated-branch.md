# ADR 0008 — Routine Maintenance Pass: Cherry-Pick #33 onto This Session's Branch

Date: 2026-07-25

Status: Accepted

## Context

This is another scheduled PR-maintenance session in the same recurring
chain that produced #30 (ADR 0004/0005/0006), #32, and #33 (ADR 0007).
#33 was itself already a clean cherry-pick of #32's 8 commits plus one new
ADR commit, onto a fresh session branch, because `main` hadn't moved since
#32 was verified. This session's job was to re-verify that nothing changed
in the meantime and, if not, repeat the same mechanical step onto *this*
session's designated branch (`claude/charming-cray-1c8jj7`).

For a junior engineer wondering why this is the second ADR in a row saying
"nothing changed" — see Consequences in ADR 0007. The short version: the
value is in the checking, not in the diff, and each pass records what it
found so the next one doesn't have to re-derive trust in "still nothing
new" from scratch.

Checked live before touching anything:

- `main` was still at `c3e6c93`, the exact SHA #33 was opened against and
  the exact SHA this session's branch (forked at merge of #29) already sat
  on. No drift to reconcile.
- `list_pull_requests(state=open)` returned exactly one result: #33 itself.
  No new PRs, no Dependabot PRs.
- `list_issues(state=open)` returned zero. No new issues.
- #33's CI: all four checks (`test` on Ruby 3.1/3.2/3.3, GitGuardian
  Security Checks) `completed` / `success`.
- #33's review threads: zero open (`get_review_comments` returned an empty
  list). The only comment on the PR (`get_comments`) is the same automated
  `gemini-code-assist[bot]` notice seen on prior passes, that its own
  review service has been sunset — not feedback to act on.
- #33's 9 commits (`838fb38` … `b40ca539`), fetched via `get_commits`,
  matched what #33's own body claims: #32's original 8 commits followed by
  #33's own ADR 0007 commit.

Given all of that, there was nothing new to fold in — this pass, like #33's
own pass over #32, is a pure repeat of the mechanical step.

## Decision

Cherry-pick #33's 9 commits (`838fb38` … `b40ca539`), unchanged and in
order, onto `claude/charming-cray-1c8jj7`. All 9 applied without conflict —
expected, since this branch and #33's source branch
(`claude/charming-cray-pec4g1`) both fork from the same `c3e6c93` `main`,
and #33's own commits are themselves an unmodified replay of #32's plus one
ADR commit.

Verified the result two ways, not one:

1. `git diff HEAD origin/claude/charming-cray-pec4g1` — empty. The two
   branches are byte-identical after the cherry-pick, the same check #33's
   own body used to confirm its cherry-pick from #32.
2. Ran the actual test and lint suite locally, with MeCab genuinely
   installed this session (`sudo apt-get install -y mecab libmecab-dev
   mecab-ipadic-utf8` — the first `apt-get update` attempt failed on
   unrelated third-party PPAs, `deadsnakes` and `ondrej/php`, returning
   `403`/"no longer signed"; installing the packages directly without
   forcing a full `apt-get update` worked fine, since MeCab itself ships
   from the default Ubuntu archive). `bundle exec rspec`: **87 examples,
   0 failures**. `bundle exec standardrb`: **0 offenses**. Both match the
   baseline #30, #32, and #33 already established.

The `rbenv init` / `PATH` gotcha documented in ADR 0007 recurred exactly as
described — `bundle exec rspec` initially reported `command not found`
despite `bundle install` reporting all gems present, because this
sandbox's `PATH` doesn't include `/opt/rbenv/shims` by default. Running
`eval "$(rbenv init -)"` before `bundle exec` fixed it immediately, with no
time lost chasing the `Gemfile.lock`, since ADR 0007 had already written
the cause down.

Opened a new PR from this branch, closed #33 pointing at it, and
best-effort deleted #33's source branch (`claude/charming-cray-pec4g1`)
plus the older `claude/charming-cray-vcicrc` (#30's branch, already
closed, still lingering on the remote per prior sessions' own best-effort
notes).

## Consequences

- The content shipped is identical to #30/#32/#33: dead `Base` predicate
  removal (ADR 0004), narrowed `ve_patch.rb` rescues (ADR 0005), the
  `standard` 1.56.0 bump (ADR 0006), the nil/empty edge-case specs, and
  #33's own re-verification ADR 0007 — nothing new landed in this pass, by
  design.
- The `rbenv init` / `PATH` gotcha is now confirmed to recur reliably in a
  fresh sandbox and to be reliably fixed by the same one-line workaround —
  worth keeping in mind if a future pass wants to fold the `eval` into a
  repo-level dev script instead of re-discovering it every session.
- If a future pass in this chain *does* find something new (a real review
  comment, a moved `main`, a fresh Dependabot PR, a new issue), the
  precedent from ADR 0004–0007 still applies: fold in what's small and
  non-conflicting, re-verify with the full suite, and write the reasoning
  down rather than silently absorbing it into a commit message alone.

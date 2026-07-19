# ADR 0005 — Narrow the Bare `rescue` Clauses in `Ve::Provider::MecabIpadic#parse`

Date: 2026-07-19
Status: Accepted

## Context

`lib/kanjika/ve_patch.rb` monkey-patches `Ve::Provider::MecabIpadic#parse` to
tolerate the underlying MeCab subprocess pipe being closed or broken mid-call.
It wraps two operations in `begin/rescue`:

1. `@stdin.puts "#{text} #{BIT_STOP}"` — writing to the subprocess's stdin.
2. `@stdout.readline` in a loop — reading lines back from the subprocess's
   stdout until the `EOS` marker.

Both `rescue` clauses were bare (implicitly `rescue StandardError`). PR #30
carried this file over unchanged from #27, and `gemini-code-assist`'s
automated review on #30 flagged both as too broad: a bare rescue also
swallows programmer errors (`NoMethodError`, `TypeError`, etc.) that have
nothing to do with the pipe, making real bugs silently disappear as "MeCab
must be down" instead of surfacing as failures.

## Decision

Narrow both clauses to the exception types the surrounding comments already
say they're guarding against:

- `@stdin.puts` → `rescue IOError, SystemCallError`. Writing to a closed or
  half-closed pipe raises `IOError` ("closed stream") or a `SystemCallError`
  subclass — most commonly `Errno::EPIPE` if the reader end is gone.
- `@stdout.readline` → `rescue IOError`. `EOFError` (raised by `readline` at
  end of stream) is itself a subclass of `IOError`, so this one clause still
  covers both "stream closed" and "no more data to read" without widening
  further.

No behavioral change for the cases the comments describe as intentional
(broken/closed pipe); the change only stops masking unrelated bugs (e.g. a
typo introduced later in this method would previously have been silently
absorbed by the broad rescue and reported as "read failed", instead of
raising).

## Consequences

- `lib/kanjika/ve_patch.rb`'s two `rescue` clauses are now `rescue IOError,
  SystemCallError` and `rescue IOError` respectively, matching each block's
  documented intent.
- `bundle exec rspec` (87 examples, 0 failures with MeCab installed) and
  `bundle exec rake standard` (no offenses) both stay green — this file has
  no dedicated spec (it only activates through the `Ve` gem's MeCab
  subprocess plumbing), so the check here is that existing conjugation specs
  still pass unchanged.
- Future edits to this patch should keep rescue clauses scoped to the
  specific I/O failure they handle, per the same reasoning: broad rescues in
  process-management code are especially prone to hiding real bugs because
  "the subprocess is flaky" is a plausible-sounding excuse for almost any
  exception.

# ADR 0001 — Install MeCab in CI and Drop EOL Ruby 3.0

Date: 2026-06-29
Status: Accepted

## Context

The CI pipeline was failing on every push with errors like:

```
NoMethodError: private method 'puts' called for nil:NilClass
  from ve-0.0.4/lib/providers/mecab_ipadic.rb:32:in 'parse'
```

The `ve` gem is a Ruby wrapper around **MeCab** — a Japanese morphological analyzer
written in C. MeCab is a system binary, not a Ruby gem. It must be installed at the
operating-system level (via `apt`, `brew`, etc.) before any Ruby code that calls it can
run. When MeCab is absent, the `ve` gem's internal parser returns `nil`, which causes
the `nil:NilClass` method error shown above.

The CI workflow called `bundle exec rake` without ever installing MeCab on the runner.
Every test that exercised verb conjugation therefore failed before the test assertions
were even reached.

Separately, the test matrix included **Ruby 3.0**, which reached end-of-life on
**31 March 2024** and no longer receives security patches. Running tests on EOL runtimes
gives false confidence: a passing CI on an unsupported Ruby does not mean the gem is
safe for production use. It also blocks the test matrix from progressing to newer
language features.

## The Lesson: System Dependencies Are Not Ruby Dependencies

A gemspec's `add_dependency` list covers only **Ruby gems** that Bundler can install.
It cannot declare system packages. When a gem wraps a native library or OS binary —
MeCab, libpq (PostgreSQL), libxml2 (Nokogiri), ImageMagick, etc. — that dependency
must be handled in three places:

1. **README** — document "requires MeCab; install with `brew install mecab` or
   `apt-get install mecab mecab-ipadic-utf8 libmecab-dev`."
2. **CI workflow** — add an explicit install step _before_ `bundle install` or
   `ruby/setup-ruby`.
3. **Developer onboarding** — a `bin/setup` script or a dev-environment section in the
   README that shows the `apt-get` or `brew` command.

Skipping step 2 is the most common omission. The gem appears to install fine
(`bundle install` succeeds), so developers assume CI will pass — and then hit a
confusing runtime error that looks like a Ruby bug rather than a missing system library.

## The Lesson: EOL Runtimes in the Test Matrix

When a Ruby version reaches EOL:

- The Ruby security team stops backporting patches.
- Gems that rely on `ObjectSpace`, GC tuning, or C extensions may start breaking on
  the EOL version while working fine on supported versions.
- CI time is wasted testing a configuration nobody should run in production.

The correct response is to **remove the EOL version from the matrix and bump
`required_ruby_version` in the gemspec**. This makes the constraint explicit and
prevents someone from accidentally deploying the gem on an unsupported runtime.

Ruby's release schedule: https://www.ruby-lang.org/en/downloads/branches/

## Decision

1. Add a `sudo apt-get install -y mecab mecab-ipadic-utf8 libmecab-dev` step in
   `.github/workflows/test.yml` before the Ruby setup and `bundle exec rake` steps.
2. Remove `'3.0'` from the CI matrix.
3. Add `'3.3'` to keep the matrix current (3.1, 3.2, 3.3).
4. Bump `actions/checkout@v3` → `@v4` (v3 reached its deprecation window).
5. Bump `required_ruby_version` in `kanjika.gemspec` from `>= 3.0.0` to `>= 3.1.0`.

## Consequences

- CI passes on all supported Ruby versions (3.1, 3.2, 3.3).
- MeCab-dependent tests can run and produce meaningful pass/fail results.
- The gemspec accurately advertises the minimum supported Ruby version.
- Any future attempt to install this gem on Ruby 3.0 will fail fast with a clear
  RubyGems error rather than a silent runtime crash at first use.

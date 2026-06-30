---
name: Bug report
about: Create a report to help us improve
title: '[BUG] '
labels: bug
assignees: ''
---

## Bug Description

A clear and concise description of what the bug is.

## To Reproduce

Steps to reproduce the behavior:

1. Initialize conjugator with verb '...'
2. Call method '....'
3. See error

**Code Example:**

```ruby
# Paste your code here
conjugator = Kanjika::Conjugator::Masu.new("食べる")
conjugator.conjugate
# Expected: "食べます"
# Actual: (describe what you got)
```

## Expected Behavior

A clear and concise description of what you expected to happen.

## Actual Behavior

A clear and concise description of what actually happened.

## Environment

- Ruby version: [e.g. 3.2.0]
- Kanjika version: [e.g. 0.1.1]
- OS: [e.g. macOS 13.0, Ubuntu 22.04]

## Additional Context

Add any other context about the problem here. For example:
- Does this happen with other similar verbs?
- Are there any error messages or stack traces?
- Have you tried with different verb types (godan, ichidan, irregular)?

# ADR 0002 — Replace Dynamic `constantize` with an Explicit Conjugator Whitelist

Date: 2026-06-29
Status: Accepted

## Context

`Kanjika::Verb#conjugate` used ActiveSupport's `constantize` to resolve a conjugator
class at runtime by constructing its name from user-supplied input:

```ruby
def conjugate(type, negative: false)
  conjugator_class = "Kanjika::Conjugator::#{type.to_s.camelize}"
  conjugator_class.constantize.new(verb).conjugate(negative: negative)
rescue NameError
  raise "Unknown form #{type}"
end
```

`constantize` converts a string to a Ruby constant. That means:

```ruby
verb.conjugate("Masu")          # → Kanjika::Conjugator::Masu  (intended)
verb.conjugate("../../../Etc")  # → Kanjika::Conjugator::::Etc (Ruby constant traversal)
verb.conjugate("Object")        # → Kanjika::Conjugator::Object → Object (top-level fallback!)
```

The `rescue NameError` provides a false sense of security: `constantize` does not just
raise `NameError` for unknown constants — it can resolve constants the caller never
intended. In pathological cases this enables **Remote Code Execution (RCE)**:

```ruby
# If a class named Kanjika::Conjugator::Kernel exists, or if constantize
# traverses up the namespace to a superclass:
verb.conjugate("Kernel")
```

This is a well-known vulnerability class in Rails applications wherever user input is
passed to `constantize`, `classify`, or `safe_constantize` without strict allow-listing.
The Rails security guide explicitly warns against it.

Additionally, the `rescue NameError` in `Kanjika.conjugate` (the top-level module
method) shadowed errors from `constantize` and re-raised them with a misleading message,
making debugging harder.

## The Lesson: Dynamic Dispatch Is a Footgun

Dynamic dispatch — resolving a method or class from a string at runtime — is a powerful
Ruby feature. It is also one of the most common sources of security vulnerabilities when
the string comes from user input.

The rule is simple:

> **Never pass user input to `constantize`, `send`, or `eval` without strict allow-listing.**

An allow-list is a Hash (or Set, or Array) of explicitly permitted values. If the input
is not in the list, the request is rejected immediately. There is no way for an attacker
to craft an input that passes the list check and reaches a dangerous constant.

```ruby
# Dangerous — allows any string to become a constant
"Kanjika::Conjugator::#{type.camelize}".constantize

# Safe — only explicit entries can be resolved
CONJUGATORS = {
  masu: Kanjika::Conjugator::Masu,
  te:   Kanjika::Conjugator::Te,
}.freeze

CONJUGATORS.fetch(type.to_sym) { raise "Unknown form #{type}" }
```

Notice that the safe version stores **the class itself** as the value, not a string to
be converted to a class later. The string→constant conversion happened once at load
time when the Hash was defined, not at request time when user input arrives.

## Decision

Replace the `constantize` pattern in `Kanjika::Verb#conjugate` with an explicit
whitelist Hash that maps form names (Symbols) to their conjugator classes:

```ruby
def conjugators
  {
    masu:      Kanjika::Conjugator::Masu,
    te:        Kanjika::Conjugator::Te,
    potential: Kanjika::Conjugator::Potential
  }
end

def conjugate(type, negative: false)
  conjugator_class = conjugators[type.to_sym]
  raise "Unknown form #{type}" unless conjugator_class

  conjugator_class.new(verb).conjugate(negative: negative)
end
```

Also remove the redundant `rescue NameError` from `Kanjika.conjugate`: since the
inner `Verb#conjugate` now raises a plain `RuntimeError` with a clear message, the outer
rescue was catching an exception that can no longer occur and re-raising a different one
— adding confusion with no benefit.

## Consequences

- An unknown conjugation form raises a `RuntimeError` with a helpful message
  ("Unknown form xyz") immediately, regardless of whether any class named
  `Kanjika::Conjugator::Xyz` exists.
- No arbitrary constant can be resolved from user-supplied input.
- Adding a new conjugator requires an explicit entry in the `conjugators` Hash — this
  is intentional; it makes the set of supported forms visible in one place.
- `Kanjika.conjugate` is simpler: it delegates to `Verb#conjugate` and lets its errors
  propagate naturally.

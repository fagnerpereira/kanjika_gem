# Security Policy

## Supported Versions

We release patches for security vulnerabilities for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |
| < 0.1   | :x:                |

## Reporting a Vulnerability

The Kanjika team takes security bugs seriously. We appreciate your efforts to responsibly disclose your findings, and will make every effort to acknowledge your contributions.

To report a security vulnerability, please use one of the following methods:

### Email

Send an email to fagnerfpr@gmail.com with the following information:

- Type of issue (e.g. buffer overflow, SQL injection, cross-site scripting, etc.)
- Full paths of source file(s) related to the manifestation of the issue
- The location of the affected source code (tag/branch/commit or direct URL)
- Any special configuration required to reproduce the issue
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit it

### GitHub Security Advisories

You can also report security vulnerabilities through [GitHub Security Advisories](https://github.com/fagnerpereira/kanjika_gem/security/advisories/new).

## What to Expect

After you submit a vulnerability report, we will:

1. Confirm receipt of your vulnerability report (within 48 hours)
2. Provide an estimated timeline for a fix
3. Notify you when the vulnerability is fixed

## Disclosure Policy

When we receive a security bug report, we will:

1. Confirm the problem and determine affected versions
2. Audit code to find any similar problems
3. Prepare fixes for all supported releases
4. Release new versions of all affected versions as soon as possible

We ask that you:

- Give us reasonable time to fix the vulnerability before making it public
- Do not access or modify data that doesn't belong to you
- Do not perform actions that could negatively affect our users

## Comments on This Policy

If you have suggestions on how this process could be improved, please submit a pull request or open an issue.

## Attribution

This security policy is adapted from the [Rails security policy](https://rubyonrails.org/security/) and follows industry best practices.

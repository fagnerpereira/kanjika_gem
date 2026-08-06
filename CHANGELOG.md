# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- ROADMAP.md with proposed features awaiting discussion
- `rubygems_mfa_required` gemspec metadata (MFA-protected gem pushes)
- CHANGELOG.md is now packaged in the built gem
- CODE_OF_CONDUCT.md with Contributor Covenant 2.0
- CONTRIBUTING.md with detailed contribution guidelines
- GitHub issue templates for bug reports and feature requests
- Pull request template for standardized contributions
- Enhanced gemspec metadata with source code and bug tracker URIs
- Examples directory with working conjugation examples
- Comprehensive README with usage examples
- MIT-LICENSE file
- GitHub Actions CI workflow
- Features section in README highlighting key capabilities
- Quick Start section in README
- Project Status section in README with complete feature checklist

### Fixed
- `lib/kanjika/errors.rb` was never required, so `Kanjika::InvalidVerbError` raised `NameError` when referenced; the duplicate inline `Kanjika::Error` definition was removed
- Method signature mismatch causing test failures
- Missing constants in Masu and Te conjugators
- Conjugate method signature in potential conjugator now accepts negative parameter
- Examples/conjugate.rb now uses require_relative for local development

### Removed
- Dead constants `ICHIDAN_TYPE`, `GODAN_TYPE`, `IRREGULAR_TYPE`, `KURU` from `Conjugator::Base` (no references anywhere in lib, spec, or examples)
- Tracked `lib/kanjika/.DS_Store` junk file

### Improved
- README documentation structure and clarity
- CHANGELOG format following Keep a Changelog standard
- Project organization and contribution workflow

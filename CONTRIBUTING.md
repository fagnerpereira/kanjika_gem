# Contributing to Kanjika

First off, thank you for considering contributing to Kanjika! It's people like you that make Kanjika such a great tool for working with Japanese verbs.

## Code of Conduct

This project and everyone participating in it is governed by the [Kanjika Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to fagnerfpr@gmail.com.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

* **Use a clear and descriptive title**
* **Describe the exact steps to reproduce the problem**
* **Provide specific examples** - Include code snippets, verb examples, or test cases
* **Describe the behavior you observed** and what behavior you expected to see
* **Include Ruby version and gem version** information

Example bug report:

```markdown
## Bug: Incorrect te-form conjugation for verb 行く

### Expected Behavior
Kanjika::Conjugator::Te.new("行く").conjugate should return "行って"

### Actual Behavior
Returns "行いて" instead

### Steps to Reproduce
1. Create a Te conjugator with "行く"
2. Call conjugate method
3. See incorrect output

### Environment
- Ruby version: 3.2.0
- Kanjika version: 0.1.1
- OS: Ubuntu 22.04
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

* **Use a clear and descriptive title**
* **Provide a detailed description** of the suggested enhancement
* **Provide specific examples** to demonstrate the steps or show how the enhancement would be useful
* **Explain why this enhancement would be useful** to most Kanjika users

### Adding New Conjugation Forms

If you'd like to add a new conjugation form (e.g., conditional, imperative), follow these steps:

1. Create a new file in `lib/kanjika/conjugator/` (e.g., `conditional.rb`)
2. Inherit from `Kanjika::Conjugator::Base`
3. Implement the `conjugate` method
4. Add comprehensive tests in `spec/kanjika/conjugator/`
5. Update the README with usage examples
6. Add require statement to `lib/kanjika.rb`

Example structure:

```ruby
# lib/kanjika/conjugator/conditional.rb
module Kanjika
  module Conjugator
    class Conditional < Base
      def conjugate(negative: false)
        # Implementation here
      end
    end
  end
end
```

### Pull Requests

* Fill in the required template
* Follow the Ruby style guide (we use [Standard](https://github.com/testdouble/standard))
* Include tests that cover your changes
* Update documentation as needed
* End all files with a newline
* Ensure all tests pass before submitting

## Development Setup

1. Fork and clone the repository:

```bash
git clone https://github.com/YOUR-USERNAME/kanjika_gem.git
cd kanjika_gem
```

2. Install dependencies:

```bash
bundle install
```

3. Create a branch for your changes:

```bash
git checkout -b feature/my-new-feature
```

4. Make your changes and add tests

5. Run the test suite:

```bash
bundle exec rake spec
```

6. Check code style:

```bash
bundle exec rake standard
```

7. Fix any style issues:

```bash
bundle exec standardrb --fix
```

8. Commit your changes:

```bash
git commit -m "Add some feature"
```

9. Push to your fork:

```bash
git push origin feature/my-new-feature
```

10. Open a Pull Request

## Testing Guidelines

* All new code should include tests
* Tests should cover both positive and negative cases
* Include tests for all verb types (ichidan, godan, irregular)
* Test edge cases and special verbs (like 行く for te-form)

Example test structure:

```ruby
RSpec.describe Kanjika::Conjugator::MyForm do
  subject(:conjugator) { described_class.new(verb) }

  describe "#conjugate" do
    context 'for godan verb "書く"' do
      let(:verb) { "書く" }
      
      it { expect(conjugator.conjugate).to eq("expected_form") }
      it { expect(conjugator.conjugate(negative: true)).to eq("expected_negative") }
    end

    context 'for ichidan verb "食べる"' do
      let(:verb) { "食べる" }
      
      it { expect(conjugator.conjugate).to eq("expected_form") }
    end

    context 'for irregular verb "する"' do
      let(:verb) { "する" }
      
      it { expect(conjugator.conjugate).to eq("expected_form") }
    end

    context 'for irregular verb "来る"' do
      let(:verb) { "来る" }
      
      it { expect(conjugator.conjugate).to eq("expected_form") }
    end
  end
end
```

## Style Guide

We use [Standard](https://github.com/testdouble/standard) for Ruby style. Key points:

* 2 spaces for indentation
* No trailing whitespace
* Use `frozen_string_literal: true` pragma
* Prefer double quotes for strings
* Keep lines under 120 characters when reasonable

## Documentation

* Update the README.md if you add new features
* Use YARD-style documentation comments for public methods
* Include code examples in documentation
* Keep examples simple and practical

## Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally after the first line

Examples:
```
Add conditional conjugation form

Implements the conditional form (-tara/-dara) for all verb types.
Includes comprehensive tests and documentation.

Fixes #123
```

## Questions?

Feel free to open an issue with your question or contact the maintainers directly.

Thank you for contributing to Kanjika!

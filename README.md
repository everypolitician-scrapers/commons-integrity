# commons-integrity

[![Build Status](https://travis-ci.org/everypolitician/commons-integrity.svg?branch=master)](https://travis-ci.org/everypolitician/commons-integrity)

## Usage

### Installation

Add to the `Gemfile` dependencies for a proto-commons- repository:

    gem 'commons-integrity', github => 'everypolitician/commons-integrity'

### Configuration

Each check you wish to run within your project should be listed in a
configuration file (by default `.integrity.yml` in the project's root
directory, though this can also be specified separately.)

This will usually specify which file(s) to run against, and any options
specific to that individual check.

For example:

```yaml
  WikidataIdentifiers:
    AppliesTo: 'boundaries/**/*.csv'
    column_name: 'WIKIDATA'
    column_case: 'fixed'
```

## Orchestration

Currently you need to create your own script to run this, and choose how
to display the errors. We plan to make both of these much simpler.

An example `bin/check` could do something like:

```ruby
  root = Pathname.new(ARGV.first || '.')
  files = Pathname.glob(root + '**/*')
  errors = files.map { |file| Commons::Integrity::Report.new(file: file).errors }
  puts errors
```

## Creating new Checks

Add new checks in `lib/commons/integrity/check/` such that they look
like existing checks.

Each should inherit from `Commons::Integrity::Check::Base` and supply
its own `errors` method.

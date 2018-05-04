# commons-integrity

[![Build Status](https://travis-ci.org/everypolitician/commons-integrity.svg?branch=master)](https://travis-ci.org/everypolitician/commons-integrity)

## Usage

Add to the `Gemfile` dependencies for a proto-commons- repository:

    gem 'commons-integrity', github => 'everypolitician/commons-integrity'

Then, to check the integrity of data from the command line, you can run:

    bundle exec ruby bin/check [files]

## Adding new Checks

Add new checks in `lib/commons/integrity/check/` such that they look
like existing checks.

Each should inherit from `Commons::Integrity::Check::Base` and supply
its own `errors` method.

Documentation for the Check should be added in [YARD](https://yardoc.org/)
format.

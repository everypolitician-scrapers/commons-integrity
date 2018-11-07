# frozen_string_literal: true

require 'test_helper'
require 'commons/integrity/check/unique_csv_identifiers'
require 'commons/integrity/config'

describe 'unique CSV identifiers' do
  let(:config) { nil }
  let(:file) { 'test/fixtures/bad_wikidata.csv' }
  subject { Commons::Integrity::Check::UniqueCSVIdentifiers.new(file, config: config) }

  it 'finds the duplicate' do
    subject.errors.size.must_equal 1
  end

  it 'gets the category right' do
    subject.errors.sample.category.must_equal :unique_csv_identifiers
  end

  it 'knows what the duplicate is' do
    subject.errors.sample.message.must_equal 'Duplicated wikidata value: Q20067765'
  end
end

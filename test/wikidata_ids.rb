# frozen_string_literal: true

require 'test_helper'
require 'commons/integrity/check/wikidata_identifiers.rb'

describe 'Wikidata identifiers' do
  let(:file) { 'test/fixtures/bad_wikidata.csv' }
  subject { Commons::Integrity::Check::WikidataIdentifiers.new(file) }

  it 'finds all errors' do
    subject.errors.size.must_equal 3
  end

  it 'has errors of the correct type' do
    subject.errors.sample.category.must_equal :wikidata_id_format
  end

  it 'complains about lower case ids' do
    subject.errors.map(&:message).must_include 'Invalid wikidata ID: q20067765'
  end

  it 'dislikes properties' do
    subject.errors.map(&:message).must_include 'Invalid wikidata ID: P39'
  end

  it 'prevents leading characters' do
    subject.errors.map(&:message).must_include 'Invalid wikidata ID: 2Q0067765'
  end
end

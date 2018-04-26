# frozen_string_literal: true

require 'test_helper'
require 'commons/integrity/check/wikidata_identifiers'
require 'commons/integrity/config'

describe 'Wikidata identifiers' do
  subject { Commons::Integrity::Check::WikidataIdentifiers.new(file, config: config) }

  describe 'default configuration' do
    let(:config) { nil }

    describe 'lower case column' do
      let(:file) { 'test/fixtures/bad_wikidata.csv' }

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

    describe 'mixed case column' do
      let(:file) { 'test/fixtures/wikidata_mixed_case.csv' }

      it 'finds all errors' do
        subject.errors.size.must_equal 1
      end

      it 'complains about lower case ids' do
        subject.errors.map(&:message).must_include 'Invalid wikidata ID: q20067765'
      end
    end
  end

  describe 'fixed column configuration' do
    let(:config) { Commons::Integrity::Config.new('test/fixtures/config/wikidata-fixed.yml') }

    describe 'mixed case column' do
      let(:file) { 'test/fixtures/wikidata_mixed_case.csv' }

      it 'finds errors when column name matches' do
        subject.errors.size.must_equal 1
      end
    end

    describe 'lower case column' do
      let(:file) { 'test/fixtures/bad_wikidata.csv' }

      it 'ignores column with wrong case' do
        subject.errors.size.must_equal 0
      end
    end
  end
end

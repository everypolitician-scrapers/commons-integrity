# frozen_string_literal: true

require 'test_helper'
require 'commons/integrity/config'
require 'commons/integrity/report'

describe 'Wikidata identifiers' do
  subject { Commons::Integrity::Report.new(file: datafile, config: config) }
  let(:datafile) { 'test/fixtures/wikidata_mixed_case.csv' }

  describe 'when no configuration' do
    let(:config) { nil }

    it 'reports no errors' do
      subject.errors.size.must_equal 0
    end
  end

  describe 'when file does not match configuration regex' do
    let(:config) { Commons::Integrity::Config.new('test/fixtures/config/match-all-tsv.yml') }

    it 'reports no errors' do
      subject.errors.size.must_equal 0
    end
  end

  describe 'when file matches configuration regex' do
    let(:config) { Commons::Integrity::Config.new('test/fixtures/config/match-all-csv.yml') }

    it 'reports errors' do
      subject.errors.size.must_equal 1
    end

    it 'has an error of the correct type' do
      subject.errors.first.category.must_equal :wikidata_id_format
    end

    it 'knows which file the error was in' do
      subject.errors.first.filename.to_s.must_equal datafile
    end

    it 'has a useful error message' do
      subject.errors.first.message.must_equal 'Invalid wikidata ID: q20067765'
    end
  end
end

# frozen_string_literal: true

require 'test_helper'
require 'commons/integrity/check/languages.rb'
require 'commons/integrity/config.rb'

describe 'Language consistency' do
  subject { Commons::Integrity::Check::Languages.new(file, config: config) }
  let(:config) { Commons::Integrity::Config.new 'test/fixtures/config/languages.yml' }

  describe 'unexpected language codes' do
    let(:file) { 'test/fixtures/languages_unexpected_popolo.json' }

    it 'finds all errors' do
      subject.errors.size.must_equal 2
    end

    it 'names unexpected languages' do
      subject.errors.map(&:message).must_include 'Unexpected language: en_US'
      subject.errors.map(&:message).must_include 'Unexpected language: zh_TW'
    end
  end

  describe 'expected language codes' do
    let(:file) { 'test/fixtures/languages_expected_popolo.json' }

    it 'finds there are no errors' do
      subject.errors.size.must_equal 0
    end
  end
end

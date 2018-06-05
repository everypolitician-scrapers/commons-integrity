# frozen_string_literal: true

require 'test_helper'
require 'commons/integrity/check/wikidata_identifiers'
require 'commons/integrity/config'

describe 'AreaPositionsKnown' do
  subject { Commons::Integrity::Check::AreaPositionsKnown.new(file, config: config) }
  let(:config) { nil }

  describe 'all known positions found' do
    let(:file) { 'test/fixtures/boundaries-good/position-data.json' }

    it 'should find no errors' do
      subject.errors.must_be_empty
    end
  end

  describe 'one position in the index file has no detailed role data' do
    let(:file) { 'test/fixtures/boundaries-missing-role-data/position-data.json' }

    it 'should find 1 error' do
      subject.errors.size.must_equal 1
    end

    it 'should be of the correct type' do
      subject.errors.first.category.must_equal :position_id_message
    end

    it 'should have the expected error message' do
      subject.errors.first.message.must_match(
        /Q18964326 was found in .*index.json but not in .*position-data.json/
      )
    end
  end
end

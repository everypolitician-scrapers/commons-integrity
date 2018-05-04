# frozen_string_literal: true

require 'test_helper'
require 'commons/integrity/config'

describe 'Config' do
  describe 'when no checks configured' do
    subject { Commons::Integrity::Config.new('test/fixtures/config/empty.yml') }

    it 'has no configured checks' do
      subject.checks.size.must_equal 0
    end
  end
end

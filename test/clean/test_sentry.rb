require_relative '../test_helper'
require 'clean/sentry'
include Clean

describe Sentry do

  describe '#new' do
    it 'must check arguments' do
      Sentry.new("", "") {|v| true}
      assert_raises(ArgumentError) { Sentry.new }
      assert_raises(ArgumentError) { Sentry.new("") }
      assert_raises(ArgumentError) { Sentry.new("", "") }
    end

    let(:sentry) { Sentry.new("","") {|v| true} }
    it 'must include Sentry' do
      assert_kind_of Sentry, sentry
    end
  end

  let(:errmsg) { "must be String[3..100]" }
  let(:sentry) {
    Sentry.new(:str, errmsg){|v| v.is_a?(String) && v.size.between?(3,100)} }

  describe '#error' do
    it 'must retrun error string' do
      assert_match errmsg, sentry.error("")
      key = "key"
      msg = "msg"
      assert_match ":#{key} #{errmsg}", sentry.error("", key)
      assert_match ":#{key} #{msg}", sentry.error("", key, msg)

      key = :key
      assert_match ":#{key} #{errmsg}", sentry.error("", key)
      assert_match ":#{key} #{msg}", sentry.error("", key, msg)
    end

    it 'must retrun nil if valid' do
      refute sentry.error("str")
    end
  end

  let(:valid) { "value" }
  let(:wrong) { "" }

  describe '#error!' do
    it 'must return value' do
      assert_equal valid, sentry.(valid)
    end

    it 'must raise ArgumentError' do
      err = assert_raises(ArgumentError) { sentry.(wrong) }
      assert_match errmsg, err.message
    end
  end

end

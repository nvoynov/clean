require_relative '../../test_helper'

describe Validator do

  # TODO: Symbol for first Sentry.new argument!
  let(:str_sentry) { Sentry.new(:str, "must be String"){|v| v.is_a?(String)} }
  let(:len_sentry) { Sentry.new(:len, "must be 3..100"){|v| v.size.between?(3, 100)} }

  describe '#scan' do
    it 'must return errors' do
      refute_empty Validator.scan(1,     :val, str_sentry, len_sentry)
      refute_empty Validator.scan("ss",  :val, str_sentry, len_sentry)
      assert_empty Validator.scan("sss", :val, str_sentry, len_sentry)
    end
  end

  describe '#errors' do
    it 'must fail with Failure for invalid arguments' do
      assert_raises(ArgumentError) { Validator.() }
      assert_raises(ArgumentError) { Validator.(1) }
      assert_raises(ArgumentError) { Validator.(1, 1) }
      assert_raises(ArgumentError) { Validator.(1, 1, 1) }
      assert_raises(ArgumentError) { Validator.(1, 1, 1, 1) }
      assert_raises(ArgumentError) { Validator.([1, 'v', str_sentry], [1]) }
    end

    it 'must return errors array' do
      refute_empty Validator.errors(1, 'val', str_sentry, len_sentry)
      refute_empty Validator.errors(1, :val, str_sentry, len_sentry)
      assert_equal 2, Validator.errors(
        [1, 'val', str_sentry],
        ["1", 'val', str_sentry],
        ["1", 'val', len_sentry]).size
    end
  end

  describe '#errors!' do
    it 'must fail' do
      err = assert_raises(Validator::Failure) {
        Validator.errors!(
          [1, :val, str_sentry],
          ["1", :key, str_sentry],
          ["1", :key, len_sentry])
      }
      assert_equal 2, err.errors.size
    end
  end

end

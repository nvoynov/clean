require_relative '../test_helper'

describe Value do

  describe 'one attribute' do
    let(:klass) { Value.punch(:foo) }

    it 'must create frozen value instance' do
      val = klass.new('foo')
      assert val.frozen?
      refute_respond_to klass, :punch
      assert_kind_of Value, val
      assert_respond_to val, :foo
      assert_equal 'foo', val.foo
    end

    it 'must compare by values' do
      v1 = klass.new('foo')
      v2 = klass.new('foo')
      v3 = klass.new('bar')

      assert_equal v1, v2
      refute_equal v1, v3
    end

    it 'hash should be equal for equal values' do
      v1 = klass.new('foo')
      v2 = klass.new('foo')
      v3 = klass.new('bar')

      assert v1.hash
      assert_equal v1.hash, v2.hash
      refute_equal v1.hash, v3.hash
    end

  end

  describe 'few attributes' do
    let(:klass) { Value.punch(:x, :y) }

    it 'must create frozen value instance' do
      val = klass.new(x: 1, y: 1)
      assert val.frozen?
      assert_kind_of Value, val
      assert_respond_to val, :x
      assert_respond_to val, :y
      assert_equal 1, val.x
      assert_equal 1, val.y
    end

    it 'must compare by values' do
      v1 = klass.new(x: 1, y: 1)
      v2 = klass.new(x: 1, y: 1)
      v3 = klass.new(x: 1, y: 2)

      assert_equal v1, v2
      refute_equal v1, v3
    end

    it 'hash should be equal for equal values' do
      v1 = klass.new(x: 1, y: 1)
      v2 = klass.new(x: 1, y: 1)
      v3 = klass.new(x: 1, y: 2)

      assert v1.hash
      assert_equal v1.hash, v2.hash
      refute_equal v1.hash, v3.hash
    end
  end

  describe 'with initialize' do
    let(:dummy) {
      Value.punch(:str, :int) do
        def initialize(str:,int:)
          fail ArgumentError unless str.is_a?(String) && !str.empty?
          fail ArgumentError unless int.is_a?(Integer)
          @str = str
          @int = int
        end
      end
    }

    it 'must be value' do
      a = dummy.new(str: 'string', int: 0)
      b = dummy.new(str: 'string', int: 0)
      c = dummy.new(str: 'string', int: 1)

      assert_equal a, b
      refute_equal a, c
      refute_equal b, c
    end

    let(:wrong_args) {[
      {},
      { unknown: 42 },
      { str: 's' },
      { str: 's', unknown: 42 },
      { int: 1 },
      { str: 1, int: 1 },
      { str: 'str', int: Object.new },
    ]}
    it 'must fail for wrong arguments' do
      wrong_args.each do |wrong|
        assert_raises(ArgumentError) { dummy.new(**wrong) }
      end
    end
  end
end

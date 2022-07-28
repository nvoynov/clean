require_relative '../../test_helper'
require 'securerandom'

describe HashStorage do

  class Foo < Entity
    attr_reader :foo
    def initialize(id: SecureRandom.uuid, foo:)
      @id = uuid!(id)
      @foo = foo
    end
  end

  class Bar < Entity
    attr_reader :bar
    def initialize(uuid: SecureRandom.uuid, bar:)
      @id = uuid!(id)
      @bar = bar
    end
  end

  class HashStorage
    attr_reader :storages
  end

  let(:storage) { HashStorage.new }

  describe '#new' do
    it 'must create entity' do
      foo = storage.new(Foo, foo: 'foo 1')
      assert foo
      assert_instance_of Foo, foo
      assert_equal 'foo 1', foo.foo

      assert_raises(ArgumentError) { storage.new(Integer) }
    end
  end

  describe '#put' do
    it 'must store entity' do
      foo = storage.new(Foo, foo: 'foo 1')
      storage.put(foo)
      storage.put(Foo.new(foo: 'foo 2'))
      storage.put(storage.new(Foo, foo: 'foo 3'))
      assert_equal 3, storage.storages[:Foo].size

      assert_raises(ArgumentError) { storage.put(1) }
    end
  end

  describe '#get' do
    it 'must return one entity' do
      foo = storage.put(Foo.new(foo: 'first'))
      storage.put(Foo.new(foo: 'second'))
      storage.put(Foo.new(foo: 'third'))

      found = storage.get(Foo, id: foo.id)
      assert found
      assert_instance_of Foo, found
      assert_equal foo.id, found.id
      assert_equal foo.foo, found.foo

      found = storage.get(Foo, foo: 'unknown')
      refute found
    end
  end

  describe '#all' do
    it 'must return array' do
      storage.put(Foo.new(foo: 'first'))
      storage.put(Foo.new(foo: 'second'))
      storage.put(Foo.new(foo: 'third'))
      a = storage.put(Foo.new(foo: 'shared'))
      b = storage.put(Foo.new(foo: 'shared'))
      assert_equal 5, storage.all(Foo).size

      found = storage.all(Foo, foo: 'shared')
      assert_equal 2, found.size
      assert_equal [a, b].map(&:id), found.map(&:id)

      not_found = storage.all(Foo, foo: 'unknown')
      assert_equal [], not_found
    end
  end


end

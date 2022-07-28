require_relative '../../test_helper'

describe Chain do

  class Chain
    attr_reader :context
    attr_reader :presenter
    public_class_method :new
    public :kwargs
  end

  let(:dummy) {
    Class.new(Service) do
      def call
        42
      end
    end
  }

  describe '#new' do
    it 'must require *services' do
      assert_raises(ArgumentError) { Chain.() }
    end

    it 'must allow empty **context' do
      chain = Chain.new(dummy, dummy)
      assert_equal Hash[], chain.context
      assert_equal Hash[], chain.presenter
    end

    let(:presenter) { {dummy => :d} }
    it 'must extract :presenter' do
      service = Chain.new(dummy, dummy, present: [dummy, :d])
      assert_equal presenter, service.presenter
      refute service.context[:present]
    end
  end

  describe 'presenter' do
    it 'must require even array' do
      err1 = -> {Chain.new(dummy, dummy, present: [dummy])}
      err2 = -> {Chain.new(dummy, dummy, present: [dummy, :d, dummy])}
      assert_raises(ArgumentError) { err1.call }
      assert_raises(ArgumentError) { err2.call }
    end

    it 'must present result in :context' do
      result = Chain.(dummy, dummy, present: [dummy, :d])
      assert_includes result, :d
      assert_equal 42, result[:d]
    end

    it 'must fail unless result is a Hash or "presented"' do
      err1 = -> { Chain.(dummy, dummy) }
      assert_raises(Chain::Failure) { err1.call }

      regular = Class.new(Service) do
        def call
          {a: 42}
        end
      end
      Chain.(regular, regular)
    end
  end

  describe '#kwargs' do
    let(:serv1) {
      Class.new(Service) do
        def initialize(a:, b:)
        end
      end
    }

    let(:kwargs) { { a: 1, b: 2 } }
    it 'must require input from :context' do
      chain = Chain.new(serv1, serv1, **kwargs)
      assert_equal kwargs, chain.kwargs(serv1)

      chain = Chain.new(serv1, serv1, a: 1)
      assert_raises(Chain::Failure) { chain.kwargs(serv1) }
    end

    # @todo it 'maybe it must search deep?'
  end

  describe 'bold services chain' do
    let(:service1) {
      Class.new(Service) do
        def call
          puts 'create'
        end
      end
    }

    let(:service2) {
      Class.new(Service) do
        def call
          puts 'update'
        end
      end
    }

    it 'must chain service1 and service2' do
      assert_output("create\nupdate\n") { Chain.(service1, service2) }
    end
  end

  describe 'mixed services chain' do
    let(:s1) {
      Class.new(Service) do
        def initialize(a:, b:, x: 2)
          @a, @b, @x = a, b, x
        end
        def call
          @a + @b + @x
        end
      end
    }

    let(:s2) {
      Class.new(Service) do
        def initialize(b:, c:)
          @b, @c = b, c
        end
        def call
          @b + @c
        end
      end
    }

    let(:s3) {
      Class.new(Service) do
        def call
        end
      end
    }

    it 'must return ?' do
      result = Chain.(
        s1, s3, s2,
        a: 1, b: 2,
        present: [s1, :c, s2, :d]
      )
      assert_equal Hash[:a=>1, :b=>2, :c=>5, :d=>7], result
    end
  end
end

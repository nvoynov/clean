require_relative '../../test_helper'

describe Adapter do

  let(:service) {
    Class.new(Service) do
      def initialize(a:, b:, c: 0)
        @a, @b, @c = a, b, c
      end
      def call
        @a + @b + @c
      end
    end
  }

  let(:adapter) {
    Class.new do
      include Adapter
      public :service_params

      def adapt(params)
        params
      end

      def present(result)
        result
      end
    end
  }

  let(:dummy) { adapter.new }

  describe '#service_call_strategy' do
    it 'must fail when #adapt result is not a Hash' do
      dummy = Class.new(adapter) do
        def adapt(params)
          []
        end
      end

      assert_raises(Adapter::Failure) {
        dummy.new.service_call_strategy(service, {a: 1, b: 2})
      }
    end

    it 'must fail for missing service required params' do
      dummy.service_call_strategy(service, {a: 1, b: 2})

      assert_raises(Adapter::Failure) {
        dummy.service_call_strategy(service, {a: 1})
      }

      assert_raises(Adapter::Failure) {
        dummy.service_call_strategy(service, {b: 1})
      }
    end

    it 'must call service with all params' do
      result = dummy.service_call_strategy(service, {a: 1, b: 2})
      assert_equal 3, result

      result = dummy.service_call_strategy(service, {a: 1, b: 2, c: 3})
      assert_equal 6, result
    end

    it 'must must ingore params extraneous to the service' do
      result = dummy.service_call_strategy(service, {a: 1, b: 2, x: nil})
      assert_equal 3, result

      result = dummy.service_call_strategy(service, {a: 1, b: 2, c: 3, x: nil})
      assert_equal 6, result
    end

    it 'must #adapt params and #present result' do
      # dummy.service_call_strategy(service, {a: 1, b: 2})
    end
  end

end

require_relative '../test_helper'
require 'clean/service'
require 'clean/service_adapter'
include Clean

describe ServiceAdapter do

  Service1 = Class.new(Service) do
    def initialize(a:, b:)
      @a, @b = a, b
    end
    def call
      @a + @b
    end
  end

  Service2 = Class.new(Service) do
    def initialize(a:, b:)
      @a, @b = a, b
    end
    def call
      @a - @b
    end
  end

  NoParams = Class.new(Service) do
    def call
      42
    end
  end

  NoResult = Class.new(Service) do
    def call
    end
  end

  let(:adopted) {
    Class.new do
      include ServiceAdapter

      @services = [
        {service: Service1, :method => :call_service1},
        {service: Service2, :method => :call_service2},
        {service: NoParams, :method => :call_noparams},
        {service: NoResult, :method => :call_noresult}]

      mount_services *@services do |service:, method:|
        define_method(method) do |**kwargs|
          service_call_strategy(service, kwargs)
        end
      end

      def adapt(params)
        params
      end

      def present(result)
        result
      end
    end
  }

  let(:dummy) { adopted.new }
  describe 'mounted services in action' do
    it 'must mount' do
      dummy.call_noparams
      dummy.call_noresult

      dummy.call_service1(a: 1, b: 2)
      dummy.call_service2(a: 9, b: 3)
      err = assert_raises(ServiceAdapter::Failure) {
        dummy.call_service1(a: 1)
      }
      assert_match 'must be provided required prameters b:', err.message

    end
  end
end

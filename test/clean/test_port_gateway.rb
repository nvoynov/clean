require_relative '../test_helper'
require 'clean/gateway'
require 'clean/service'
include Clean

describe Port do
  describe '#port' do
    let(:dummy) { Gateway.port }

    it 'must return valid Port module' do
      assert_kind_of Port, dummy
      assert_respond_to dummy, :gateway
      assert_respond_to dummy, :gateway=
    end
  end
end

describe Port do

  let(:dummy) {
    Module.new do
      extend Port
      port Gateway
    end
  }

  let(:wrong) {
    Module.new do
      extend Port
      # port Gateway - Gateway was not ported!
    end
  }

  describe '#gateway' do

    it 'must return gateway' do
      assert dummy.gateway
      assert_instance_of Gateway, dummy.gateway
    end

    it 'must raise error when no plug provided' do
      assert_raises(Port::Error) { wrong.gateway }
    end
  end

  describe '#gateway=' do
    it 'argument must be an instance of port @klass' do
      dummy.gateway = Gateway.new
      assert_raises(ArgumentError) { dummy.gateway = "42" }
    end
  end
end

describe 'Port and Gateway in action' do

  DemoGateway = Class.new(Gateway) do
    def foo
      "foo"
    end

    def bar
      "bar"
    end
  end

  DemoPort = DemoGateway.port

  let(:service) {
    require 'forwardable'

    Class.new(Service) do
      extend Forwardable
      def_delegator :DemoPort, :gateway
      def call
        "#{gateway.foo}/#{gateway.bar}"
      end
    end
  }

  it 'must use gateway' do
    assert_equal 'foo/bar', service.()
  end
end

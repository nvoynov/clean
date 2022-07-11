require_relative '../test_helper'
require 'clean/service'
include Clean

describe Service do
  describe '#call was not overrided' do
    let(:service) {
      Class.new(Service)
    }

    it 'must raise Failure' do
      assert_raises(Service::Failure) { service.() }
    end
  end

  describe 'default constructor' do
    let(:service) {
      Class.new(Service) do
        def call
          42
        end
      end
    }

    it 'must return 42' do
      assert_equal 42, service.()
    end
  end

  describe 'personal constructor' do
    let(:service) {
      Class.new(Service) do
        def initialize(a, b)
          @a, @b = a, b
        end

        def call
          @a + @b
        end
      end
    }

    it 'must return 42' do
      assert_equal 3, service.(1, 2)
    end
  end
end

# frozen_string_literal: true

module Clean
  # Port is about mounting or injecting gateways or similar
  #
  # @example
  #   class DRbGateway
  #     def initialize(uri)
  #     def create_account()
  #     def deposit()
  #   end
  #
  #    DRbPort = DRbGateway.port
  #    # OR
  #    # module DRbPort
  #    #   extend Port
  #    #   port DRbGateway
  #    # end
  #    DRbProt.gateway = DRbGateway.new(url)
  #
  #    require "forwardable"
  #    class Service
  #      extend Forwardable
  #      def_delegator :DRbPort, :gateway, :drb_service
  #
  #      def call
  #        account = drb_service.create_account
  #        drb_service.deposit(account, 100.00, 'USD')
  #      end
  #    end
  module Port

    Failure = Class.new(StandardError)

    def gateway
      fail Failure, "port constant required" unless @klass
      @gateway ||= @klass.new
    end

    def gateway=(gateway)
      fail ArgumentError.new("required an instance of #{@klass}"
      ) unless gateway.is_a?(@klass)
      @gateway = gateway
    end

    def port(klass)
      @klass = klass
    end
  end

  class Gateway
    Failure = Class.new(StandardError)

    class << self
      def port
        klass = self
        Module.new { extend Port; port klass }
      end

      def inherited(klass)
        klass.const_set(:Failure, Class.new(klass::Failure))
        super
      end
    end
  end

end

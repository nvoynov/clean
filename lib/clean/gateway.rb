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

    class Error < StandardError
    end

    def gateway
      raise Error, "port constant required" unless @klass
      @gateway ||= @klass.new
    end

    def gateway=(gateway)
      raise ArgumentError.new("required an instance of #{@klass}"
      ) unless gateway.is_a?(@klass)
      @gateway = gateway
    end

    def port(klass)
      @klass = klass
    end
  end

  class Gateway
    def self.port
      klass = self
      Module.new { extend Port; port klass }
    end
  end

end

# frozen_string_literal: true

require_relative 'service'

module Clean

  # ServiceAdapter frames basic shape of integration domain services
  #   for various technology interfaces like Web, DRb, MessageBroker.
  #   It is supposet that every domain service has the same kind of
  #   interface with keyword parameters.
  #
  # @example
  #   include App::Services
  #
  #   class WebAdapter
  #     include ServiceAdapter
  #     mount PlusService,  :method => :get
  #     mount MinusService, :method => :get
  #
  #   end
  #
  # @todo take into account that the module will be included
  #       and its methods should
  module ServiceAdapter
    Failure = Class.new(StandardError)

    class << self
      def included(klass)
        klass.extend(ClassMethods)
      end
    end

    module ClassMethods
      # class method for mounting services
      # @example
      #   class App < Sinatra::Base
      #     include ServiceWebAdapter
      #
      #     @services = [
      #       {url: '/api/v1/get-service-1', method: 'GET', service: Service1},
      #       {url: '/api/v1/get-service-2', method: 'GET', service: Service2},
      #       {url: '/api/v1/get-service-3', method: 'GET', service: Service3},
      #     ]
      #
      #     mount_services @services do |url:, method:, service:|
      #       route(method, url) do
      #         service_call_strategy(service, request.body, params)
      #       end
      #     end
      #
      #     # regular sinatra code ...
      #   end
      #
      def mount_services(*metadata, &block)
        metadata.each{|meta| block.(**meta)}
      end
    end

    # call service
    # @param service [Service] to call
    # @param params [Array] raw parameters received by the adapter
    def service_call_strategy(service, *params)
      # it should #adopt, then #slice/take for service
      adapted = adapt(*params)
      fail Failure, "#adopt(*params) must return Hash" unless adapted.is_a?(Hash)

      # get required parameters of the service
      keyreq = service_params(service)
        .select{|(spec, _)| spec == :keyreq}
        .map{|(_, key)| key}

      missed = keyreq - adapted.slice(*keyreq).keys
      mismsg = missed.map{ |m| "#{m}:" }.join(', ')
      fail Failure.new("must be provided required prameters #{mismsg}"
      ) unless missed.empty?

      # get all parameters of the service
      separa = service_params(service).map{|(_, key)| key}
      seargs = adapted.slice(*separa)
      present(service.(**seargs))
    rescue Service::Failure => ex
      error(ex)
    end

    # translate *params to use for service.call()
    # @params params [*params] face params as the face got it from user
    # @retrun [Hash] sevice params suitable for service.call(**adapt)
    def adapt(*params)
      raise Failure, "#adapt must be overriden"
    end

    # present result of service.call to tech face
    def present(result)
      raise Failure, "#present must be overriden"
    end

    # hadnler for Service::Failure
    def error(ex)
    end

    protected

    def service_params(service)
      service.instance_method(:initialize).parameters
        .select{ |(spec, _)| spec == :keyreq || spec == :key }
    end
  end

end

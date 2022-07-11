# frozen_string_literal: true

require_relative 'service'

module Clean

  # Chain of service calls with shared arguments context
  #
  # @example bold chain
  #   ServiceChain.(CreateDir, CreateFiles, ReportDone)
  #
  # @example with results presentation
  #   class PlusService
  #     def initialize(a:, b:)
  #       @a, @b = a, b
  #     end
  #     def call
  #       @a + @b
  #     end
  #   end
  #
  #   class MultService
  #     def initialize(x:, y:)
  #       @x, @y = x, y
  #     end
  #     def call
  #       @x * @y
  #     end
  #   end
  #
  #  ServiceChain.(
  #    PlusService, MultService,   # services to chain
  #    a: 1, b: 2, y: 3            # shared context
  #    present: [PlusService, :x]  # services presentation inside the context
  #  )                             # => 9
  #
  class ServiceChain < Service
    def initialize(*services, **context)
      raise ArgumentError, 'services for chain required' if services.empty?
      @services = services
      @context = Hash[context]
      @presenter = separate_presenter
    end

    def call
      @services.each do |service|
        params = kwargs(service)
        result = service.(**params)
        next unless result
        present(service, result)
      end
      @context # or last result?
    end

    protected

      def present(service, result)
        presenter = @presenter[service]
        raise Failure.new("#{service} must be either presented or return Hash"
        ) unless presenter || result.is_a?(Hash)
        !!presenter ? @context[presenter] = result : @context.merge!(result)
      end

      def separate_presenter
        return {} unless @context[:present]
        src = @context.delete(:present)
        raise ArgumentError.new(
          "present: [A, :a, B, :b] must be an Array of even size"
        ) unless src.is_a?(Array) && src.size.even?
        ary = []; ary << src.shift(2) until src.empty?
        ary.to_h
      end

      # Builds keyword arguments for calling service
      # @param service [Class] the service to build arguments
      # @return [Hash] of keyword arguments
      def kwargs(service)
        params = service.instance_method(:initialize).parameters
          .select{ |(spec, _)| spec == :keyreq || spec == :key }
        # puts "kwargs(service) #{params}"
        params.each_with_object({}) do |(spec, kw), memo|
          value = context_value(kw)
          raise Failure.new("#{service} required argument :#{kw} not found"
          ) if spec == :keyreq && value.nil?
          next unless value
          memo[kw] = value
        end
      end

      # TODO: To dig or not to dig inside the @context? @see MemoDigger
      # finds keyword parameter value inside the pipe context
      # @param kwparam [Symbol] keyword parameter
      # @return [Object] the kwparam value or nil when context does not have it
      def context_value(kw)
        @context[kw]
      end

      require 'delegate'
      # Deep digging decorator for hashes
      #
      #   User = Struct.new(:name, :mail)
      #   memo = {a: 1, b: {two: 2, three: 3},
      #     u: User.new("John", "john@co.com") }
      #
      #   digger = MemoDigger.new(memo)
      #   digger.(:a)       # => 1
      #   digger.(:two)     # => 2
      #   digger.(:name)    # => "John"
      #   digger.(:unknown) # => nil
      #
      class MemoDigger < SimpleDelegator
        def call(kw, obj = __getobj__)
          if obj.is_a?(Hash)
            return obj[kw] if obj.include?(kw)
            obj.values.each do |val|
              found = call(kw, val)
              return found if found
            end
          end
          return obj.send(kw) if obj.respond_to?(kw)
        end
      end

  end

end

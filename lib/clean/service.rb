# frozen_string_literal: true

module Clean
  # Service like ServiceObject, Command, etc.
  #
  # @example just call without parameters
  #   class BoldService < Service
  #     def call
  #       42
  #     end
  #   end
  #
  # @example with parameters
  #   class PlusService < Service
  #     def initialize(a, b)
  #       @a, @b = a, b
  #     end
  #
  #     def call
  #       42
  #     end
  #   end
  #
  class Service
    Failure = Class.new(StandardError)

    def self.call(*args, **kwargs, &block)
      new(*args, **kwargs, &block).call
    end

    private_class_method :new

    def call
      raise Failure, "#{self.class.name}#call must be overrided"
    end

    # from polist gem
    def self.inherited(klass)
      klass.const_set(:Failure, Class.new(klass::Failure))
      super
    end
  end

end

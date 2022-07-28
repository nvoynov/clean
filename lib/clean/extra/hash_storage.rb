require_relative '../storage'

module Clean

  class HashStorage < Storage
    def initialize
      @storages = {}
    end

    # Puts entity to the storage
    # @param entity [Entity] to put into the storage
    # @return [Entity]
    #
    # @todo each entity stored inside should be frozen? maybe keyword arg?
    # @todo methods should be thread-safe
    def put(entity)
      super(entity)
      storage(entity.class)
        .store(entity.id, entity)
    end

    # Return first entity klass instance matched to keyword arguments
    # @param klass [Class<Entity>] entity class to get from
    # @param kwargs [keyword arguments] matching criterias
    # @return [Entity] first entity of klass that matches to **kwargs
    def get(klass, **kwargs)
      super(klass, **kwargs)
      fail Failure, "**kwargs required" if kwargs.empty?
      fn = filter.(kwargs)
      storage(klass).values.find(&fn)
    end

    # Return collection of entitied matches **kwargs criterias
    # @param klass [Class<Entity>] entity class to get from
    # @param kwargs [keyword arguments] matching criterias
    # @return [Array<klass>] entities of klass match to **kwargs
    def all(klass, **kwargs)
      super(klass, **kwargs)
      storage(klass).values.then{|items|
        return items if kwargs.empty?
        fn = filter.(kwargs)
        items.select(&fn)
      }
    end

    protected

      # @returns [Proc] for matching kwargs
      def filter
        (proc {|kwargs, e|
          kwargs.all? do |key, val|
            meth = key.to_sym
            fail "#{e} does not respond to :#{key}" unless e.respond_to? meth
            case val
            when Proc
              val.(e.send(meth))
            when Regexp
              e.send(meth) =~ val
            else
              e.send(meth) == val
            end
          end
        }).curry
      end

      def storage(klass)
        key = klass.name
          .split(/::/)
          .last.to_sym

        @storages.store(key, {}) unless @storages.key?(key)
        @storages.fetch(key)
      end

  end
end

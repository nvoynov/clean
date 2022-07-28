require_relative 'entity'

module Clean
  # Entity storage interface
  #
  # @example
  #
  # @todo maybe it is a module? and main class is gateway?
  class Storage

    Failure = Class.new(StandardError)

    def self.inherited(klass)
      klass.const_set(:Failure, Class.new(klass::Failure))
      super
    end

    # Creates a new entity instance of klass with kwargs
    # @param [Class<Entity>] entity class
    # @param [keyword arguments] entity constructor arguments
    # @return [Entity] a new instance of #klass w
    def new(klass, **kwargs)
      MustbeEntityClass.(klass)
      klass.new(**kwargs)
    end

    # Puts entity to the storage
    # @param entity [Entity] to put into the storage
    # @return [Entity]
    # @todo put multiple entities? of the same klass? other classes?
    def put(entity)
      MustbeEntity.(entity)
    end

    # Return first entity klass instance matched to keyword arguments
    # @param klass [Class<Entity>] entity class to get from
    # @param kwargs [keyword arguments] matching criterias
    # @return [Entity] first entity of klass that matches to **kwargs
    def get(klass, **kwargs)
      MustbeEntityClass.(klass)
    end

    # Return collection of entitied matches **kwargs criterias
    # @param klass [Class<Entity>] entity class to get from
    # @param kwargs [keyword arguments] matching criterias
    # @return [Array<klass>] entities of klass match to **kwargs
    def all(klass, **kwargs)
      MustbeEntityClass.(klass)
    end

    # !!! QUERY MUST BE SEPARATE SERVICE, NOT A STORAGE INTERFACE !!!
    # Return collection based on entity attributes
    # @param klass [Class<Entity>] entity class to get from
    # @param kwargs [keyword arguments] matching criterias
    # def query(klass, attrs: nil, where: nil, order: nil, limit: nil, offset: nil)
  end
end

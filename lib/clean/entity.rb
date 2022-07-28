require 'securerandom'
require_relative 'sentry'

module Clean

  MustbeEntity = Sentry.new('entity', 'must be Entity'
  ) {|v| v.is_a?(Entity)}

  MustbeEntityClass = Sentry.new('entity', 'must be Entity'
  ) {|v| v.is_a?(Class) && v < Entity}


  # Simple entity class some sort of Struct with #id attribute as UUID v4
  #
  # @example it might be enough to start
  #   User = Entity.punch(:name, :email)
  #   bob = User.new(name: 'Bob', email: 'bob@server.com')
  #   bob.id   # => UUDI v2 (SecureRandom.uuid)
  #   bob.to_h # => {name: 'Bob', email: 'bob@server.com'}
  #
  # @example create regular class for more advanced cases
  #   class User < Entity
  #     attr_reader :name, :email
  #     def initialize(id: SecureRandom.uuid, name:, email:)
  #       # skipped ..
  #     end
  #   end
  #   bob = User.new(name: 'Bob', email: 'bob@server.com')
  #
  class Entity
    class << self
      def inherited(klass)
        klass.singleton_class.undef_method :punch
        super
      end

      def punch(*props, &block)
        Class.new(self) do
          const_set :PROPERTIES, props
          attr_reader(:hash, *props)
          class_eval(&block) if block_given?
        end
      end
    end

    attr_reader :id

    def initialize(**kwargs)
      unknown = kwargs.keys - self.class::PROPERTIES
      fail ArgumentError, "Unknown properties #{unknown}" if unknown.any?

      missing = self.class::PROPERTIES - kwargs.keys
      fail ArgumentError, "Missing properties #{missing}" if missing.any?

      @id = uuid!(kwargs.delete(:id) || SecureRandom.uuid)
      kwargs.each{|key,val| set_property(key, val)}
    end

    def to_h(obj = self)
      return {} unless obj.respond_to?(:instance_variables)

      key = proc{|var| var.to_s.delete_prefix(?@).to_sym}
      obj.instance_variables # those variables must have attr_reader!
        .select{|var| obj.respond_to?(key.(var))}
        .each_with_object({}){|var, memo|
          val = obj.instance_variable_get(var)
          memo.merge!(key.(var) =>
            case val
            when Entity
              to_h(val)
            when Array
              val.map{|v| to_h(v)}
            else
              val
            end
          )
        }
    end

    protected

      def set_property(key, val)
        instance_variable_set("@#{key.to_s}", val)
      end

      def get_property(key)
        [key.to_s.gsub(/^@/, '').to_sym, instance_variable_get(key)]
      end

      def uuid?(id)
        id.is_a?(String) && id.size == 36 && id =~ MATCHUUID
      end

      def uuid!(id)
        fail ArgumentError, ':id must be UUIDv4 string' unless uuid?(id)
        id
      end

      MATCHUUID = %r{^\h{8}-\h{4}-4\h{3}-\h{4}-\h{12}$}.freeze
  end
end

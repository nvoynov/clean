module Clean

  # Immutable Value Object
  #
  # @example
  #   JustValue = Value.punch(:value)
  #   val = JustValue.new(1)
  #   val.value # => 1
  #
  #   Point = Value.punch(:x, :y)
  #   a = Point.new(x: 1, y: 2)
  #   a.x   # => 1
  #   a.y   # => 2
  #
  #   Dummy = Value.punch(:str, :int) do
  #     def initialize(str:,int:)
  #       fail ArgumentError unless str.is_a?(String) && !str.empty?
  #       fail ArgumentError unless int.is_a?(Integer)
  #       @str = str
  #       @int = int
  #     end
  #   end
  #   a = Dummy.new(str: 1, int: 1) # => ArgumentError
  #
  class Value
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

    def initialize(*args, **kwargs)
      onearg = proc{ args.size == 1 && kwargs.empty? }
      fewkwa = proc{ args.empty? && kwargs.size >= 2 }
      if onearg.()
        key = self.class.const_defined?(:PROPERTIES) ? self.class::PROPERTIES.first : "value"
        set_property(key, args.first)
        @hash = self.class.hash ^ args.first.hash
      elsif fewkwa.()
        unknown = kwargs.keys - self.class::PROPERTIES
        fail ArgumentError, "Unknown properties #{unknown}" if unknown.any?
        missing = self.class::PROPERTIES - kwargs.keys
        fail ArgumentError, "Missing properties #{missing}" if missing.any?
        kwargs.each{|key,val| set_property(key, val)}
        @hash = self.class.hash ^ these_values.hash
      else
        fail ArgumentError, "required one positional or few keywords arguments"
      end
      freeze
    end

    def ==(other)
      return false unless self.class == other.class
      these_variables.all?{|key|
        self.send(key) == other.send(key)
      }
    end
    alias :eql? :==

    def to_h
      these_variables
        .map{|v| [v, get_property(v)]}
        .to_h
    end

    protected

      def set_property(key, val)
        instance_variable_set("@#{key.to_s}", val)
      end

      def get_property(key)
        instance_variable_get("@#{key.to_s}")
      end

      def these_variables
        instance_variables
          .map{|var| var.to_s.delete_prefix(?@).to_sym}
          .select{|key| respond_to?(key)}
          .tap{|key| key.delete(:hash)}
      end

      def these_values
        these_variables.map{|key| send(key)}
      end
  end

end

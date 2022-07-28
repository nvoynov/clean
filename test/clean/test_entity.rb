require_relative '../test_helper'

module SharedEntityTest
  extend Minitest::Spec::DSL

  it 'must be entity' do
    entity = klass.new(**attrs)
    assert entity
    assert_kind_of Entity, entity
    [:name, :email, :id, :to_h].each {|m|
      assert_respond_to entity, m
    }
    refute_respond_to klass, :punch

    assert_raises(ArgumentError) {
      klass.new(life_the_universe_and_everything: 42)
    }
  end

  it '#to_h must return hash' do
    hash = klass.new(**attrs).to_h
    assert_equal attrs, hash.tap{|h| h.delete(:id)}
  end

end

describe Entity do
  let(:attrs) { {name: 'dummy', email: 'dummy@co.com'} }

  describe 'self#punch' do
    let(:klass) { Entity.punch(:name, :email) }
    include SharedEntityTest
  end

  describe 'custom' do
    let(:klass) {
      Class.new(Entity) do
        attr_reader :name, :email
        def initialize(id: SecureRandom.uuid, name:, email:)
          @id = uuid!(id)
          @name = name
          @email = email
        end
      end
    }

    include SharedEntityTest
  end
end

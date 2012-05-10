module FactoryGirl
  class DefinitionList
    include Enumerable

    def initialize(definitions = [])
      @definitions = definitions
    end

    def each(&block)
      @definitions.each &block
    end

    def callbacks
      @definitions.map(&:callbacks).flatten
    end

    def attributes
      @definitions.map {|definition| definition.attributes.to_a }.flatten
    end

    def to_create
      map(&:to_create).compact.last
    end

    delegate :[], :==, :index, to: :@definitions
  end
end

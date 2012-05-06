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

    delegate :[], :==, :index, to: :@definitions
  end
end

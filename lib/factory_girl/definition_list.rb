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

    def custom_to_create_after(definition)
      if last_definition_with_custom_to_create &&
        definition != last_definition_with_custom_to_create &&
        index(last_definition_with_custom_to_create) > index(definition)

        last_definition_with_custom_to_create.to_create
      end
    end

    delegate :[], :==, :index, to: :@definitions

    private

    def last_definition_with_custom_to_create
      @last_definition_with_custom_to_create ||= select do |definition|
        definition.custom_to_create?
      end.last
    end
  end
end

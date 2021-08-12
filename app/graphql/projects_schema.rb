class ProjectsSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  # Opt in to the new runtime (default in future graphql-ruby versions)
  use GraphQL::Execution::Interpreter
  use GraphQL::Analysis::AST

  # Add built-in connections for pagination
  use GraphQL::Pagination::Connections

  def self.resolve_type(_type, object, _ctx)
    type_class = "::Types::#{object.class}Type".safe_constantize

    raise ArgumentError, "Cannot resolve type for class #{object.class.name}" unless type_class.present?

    type_class
  end
  
  def self.object_from_id(node_id, _ctx)
    print 'in from id method: ' + node_id
    return unless node_id.present?

    record_class_name, record_id = GraphQL::Schema::UniqueWithinType.decode(node_id)
    record_class = record_class_name.safe_constantize
    record_class&.find_by id: record_id
  end

  def self.id_from_object(object, _type, _ctx)
    GraphQL::Schema::UniqueWithinType.encode(object.class.name, object.id)
  end
end

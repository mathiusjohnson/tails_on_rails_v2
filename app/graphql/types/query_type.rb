module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"

    def test_field
      "Hello World!"
    end

    field :me, Types::UserType, null:false
        description "the current user"

    def me
      User.first
    end

    field :projects, [Types::ProjectType], null: false,
      description: "the projects for the current user"

    def projects
      Project.all
    end
  end
end

module Types
  class QueryType < Types::BaseObject
    add_field GraphQL::Types::Relay::NodeField
    add_field GraphQL::Types::Relay::NodesField

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"

    def test_field
      "Hello World!"
    end

    field :me, Types::UserType, null:false
        description "the current user"

    def me
      context[:current_user]
    end

    field :projects, [Types::ProjectType], null: false,
      description: "the projects for the current user"

    def projects
      context[:current_user].projects
    end


    field :all_links, resolver: Resolvers::LinksSearch
    field :_all_links_meta, QueryMetaType, null: false

    def _all_links_meta
      Link.count
    end

  end
end

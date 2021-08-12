module Types
  class UserType < BaseNode
    field :id, Int, null: false
    field :email, String, null: false
    field :votes, [VoteType], null: false
    field :links, [LinkType], null: false
  end
end

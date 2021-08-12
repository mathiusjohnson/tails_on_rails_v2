module Types
  class UserType < BaseNode
    field :id, Int, null: false
    field :email, String, null: false

  end
end

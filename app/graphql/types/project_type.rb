module Types
  class ProjectType < BaseNode
    field :id, Int, null: false
    field :title, String, null: false
    field :user, UserType, null: false, method: :user
  end
end

module Types
  class MutationType < BaseObject
    field :create_user, mutation: Mutations::CreateUser
    field :signin_user, mutation: Mutations::SignInUser
    field :create_link, mutation: Mutations::CreateLink
    field :update_link, mutation: Mutations::UpdateLink
    field :destroy_link, mutation: Mutations::DestroyLink
    field :create_vote, mutation: Mutations::CreateVote
  end
end
module Mutations
  
  class CreateLink < BaseMutation
    argument :description, String, required: true
    argument :url, String, required: true
    # argument :user_id, Int, required: true

    type Types::LinkType
    
    def resolve(description: nil, url: nil)
      byebug
      Link.create!(
        description: description,
        url: url,
        user: context[:current_user]
      )
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
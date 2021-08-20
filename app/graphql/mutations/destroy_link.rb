module Mutations
  
  class DestroyLink < BaseMutation
    argument :id, String, required: true

    type Types::LinkType
    
    def resolve(id: )
      link = ProjectsSchema.object_from_id(id, nil)
      Link.find(link["id"]).destroy

    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
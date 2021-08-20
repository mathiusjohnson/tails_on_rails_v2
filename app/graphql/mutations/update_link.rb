module Mutations
  
  class UpdateLink < BaseMutation
    argument :id, String, required: true
    argument :description, String, required: true
    argument :url, String, required: true

    type Types::LinkType
    
    def resolve(id: nil, **attributes)
      link = ProjectsSchema.object_from_id(id, nil)
      Link.find(link["id"]).tap do |link|
        link.update!(attributes)
      end

    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
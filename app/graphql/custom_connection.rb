class CustomConnection < GraphQL::Pagination::Connection
  def nodes
    results.slice(0, page_size) # Remove the extra result we fetched to check if there's another page
  end

  def cursor_for(item)
    Base64.encode64(item.id.to_s)
  end

  def has_next_page
    return false unless direction == :forward
  
    results.size > page_size
  end
  
  def has_previous_page
    return false unless direction == :backward
  
    results.size > page_size
  end
  
  def page_size
    if direction == :forward
      @first_value || max_page_size
    elsif direction == :backward
      @last_value || max_page_size
    end
  end
  
  def results
    @_results ||= begin
      if direction == :forward
        # If there’s an after cursor, decode it and only query for records with an id that come after that cursor 
        @items = @items.where('id > ?', Base64.decode64(@after_value)) if @after_value.present?
      elsif direction == :backward
        # If there’s a before cursor, decode it and only query for records with an id that come before that cursor 
        @items = @items.where('id < ?', Base64.decode64(@before_value)) if @before_value.present?
        @items = @items.reverse_order
      end
  
      @items.limit(page_size + 1) # Fetch one extra result to determine if there's another page
    end
  end

  def direction
    if @before_value.present? || @last_value.present?
      :backward
    else
      # Fall back to forward by default
      :forward
    end
  end
end
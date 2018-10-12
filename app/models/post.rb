class Post < ApplicationRecord
  scope :_title, ->(title) { where(title: title) }
  scope :created_at_desc, -> { order(created_at: :desc) }
  def to_json
    {
      title: title,
      body: body,
      link_to_post: link_to_post,
      created_at: created_at.iso8601,
      updated_at: updated_at.iso8601,
      meta: { id: created_at.to_i, timestamp: created_at.to_i }
    }
  end

  def to_limited_json
    { id: id }
  end
end

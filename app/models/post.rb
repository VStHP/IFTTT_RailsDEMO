class Post < ApplicationRecord
  validates :content, presence: true, length: { maximum: 100 }
  validates :hashtag, length: { maximum: 50 }

  scope :_hashtag, ->(hashtag) { where(hashtag: hashtag) }
  scope :created_at_desc, -> { order(created_at: :desc) }
  def to_json
    {
      content: content,
      hashtag: hashtag,
      created_at: created_at.iso8601,
      updated_at: updated_at.iso8601,
      meta: { id: created_at.to_i, timestamp: created_at.to_i }
    }
  end

  def to_limited_json
    { id: id }
  end
end

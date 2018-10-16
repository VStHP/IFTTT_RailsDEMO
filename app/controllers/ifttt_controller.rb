class IftttController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :return_errors_unless_valid_service_key
  before_action :return_errors_unless_valid_action_fields, only: :create_new_post
  before_action :return_errors_if_missing_trigger_title_field, only: :new_post_with_hashtag

  def status
    head :ok
  end

  def setup
    data = {
      samples: {
        triggers: {
          new_post_with_hashtag: { hashtag: 'ifttt' }
        },
        actions: {
          create_new_post: {
            hashtag: 'ifttt',
            content: 'How are you today?',
            test: true
          }
        }
      }
    }

    render plain: { data: data }.to_json
  end

  def create_new_post
    post = Post.new(post_params)
    post.save if params.dig(:actionFields, :test).nil?
    data = [post.to_limited_json]
    render plain: { data: data }.to_json
  end

  def new_post_with_hashtag
    data = Post._hashtag(params.dig(:triggerFields, :hashtag))
               .order(created_at: :desc).map(&:to_json)
               .first(params[:limit] || 50)
    render plain: { data: data }.to_json
  end

  private

  def post_params
    params.require(:actionFields).permit(:content, :hashtag)
  end

  def return_errors_unless_valid_service_key
    return if request.headers['HTTP_IFTTT_SERVICE_KEY'] == ENV['IFTTT_SERVICE_KEY']

    return render plain: { errors: [{ message: '401' }] }.to_json, status: 401
  end

  def return_errors_unless_valid_action_fields
    if params.dig(:actionFields, :hashtag).blank? || params.dig(:actionFields, :content).blank?
      return render plain: { errors: [{ status: 'SKIP', message: '400' }] }.to_json, status: 400
    end
  end

  def return_errors_if_missing_trigger_title_field
    if params.dig(:triggerFields, :hashtag).blank?
      return render plain: { errors: [{ status: 'SKIP', message: '400' }] }.to_json, status: 400
    end
  end
end

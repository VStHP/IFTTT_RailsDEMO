class IftttController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :return_errors_unless_valid_service_key
  before_action :return_errors_unless_valid_action_fields, only: :create_new_post
  before_action :return_errors_if_missing_trigger_title_field, only: :new_post_with_title

  def status
    head :ok
  end

  def setup
    data = {
      samples: {
        triggers: {
          new_post_with_title: { title: 'Blog no1' }
        },
        actions: {
          create_new_post: { body: 'How are you today?' }
        }
      }
    }

    render plain: { data: data }.to_json
  end

  def create_new_post
    post = [Post.create(post_params).to_limited_json]
    render plain: { data: post }.to_json
  end

  def new_post_with_title
    data = Post._title(params.dig(:triggerFields, :title))
               .order(created_at: :desc).map(&:to_json)
               .first(params[:limit] || 50)
    render plain: { data: data }.to_json
  end

  private

  def post_params
    params.require(:actionFields).permit(:body)
  end

  def return_errors_unless_valid_service_key
    return if request.headers['HTTP_IFTTT_SERVICE_KEY'] == ENV['IFTTT_SERVICE_KEY']

    return render plain: { errors: [{ message: '401' }] }.to_json, status: 401
  end

  def return_errors_unless_valid_action_fields
    if params.dig(:actionFields, :body).blank?
      return render plain: { errors: [{ status: 'SKIP', message: '400' }] }.to_json, status: 400
    end
  end

  def return_errors_if_missing_trigger_title_field
    if params.dig(:triggerFields, :title).blank?
      return render plain: { errors: [{ status: 'SKIP', message: '400' }] }.to_json, status: 400
    end
  end
end

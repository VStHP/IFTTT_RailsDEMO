class PostsController < ApplicationController
  def create
    @post = Post.new(post_params)
    if @post.save
      @success_message = 'Your post has been posted successfully!'
    end
  end

  def index
    @post = Post.new
    @posts = Post.created_at_desc.paginate(page: params[:page], per_page: 15)
  end

  def destroy
    load_post
    return if @danger_message
    if @post.delete
      @success_message = 'Deleted post successfully'
    else
      @danger_message = 'Deleted post failed'
    end
  end

  private

  def load_post
    @post = Post.find_by(id: params[:id])
    @danger_message = 'Not found this post' if @post.nil?
  end

  def post_params
    params.require(:post)
          .permit(:content, :hashtag)
  end
end

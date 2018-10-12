class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.link_to_post = post_url([@post, @post.id])
    if @post.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    return if @post
    redirect_to root_path
  end

  def index
    @posts = Post.created_at_desc.paginate(page: params[:page], per_page: 15)
  end

  private

  def post_params
    params.require(:post)
          .permit(:title, :body)
  end
end

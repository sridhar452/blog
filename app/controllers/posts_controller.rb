class PostsController < ApplicationController
  before_action :authenticate_user!,except: [:index, :show]

  def index
    if params[:tag]
      @posts = Post.tagged_with(params[:tag])
    else
      @posts = Post.all.order('created_at DESC')
      end
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to @post
    else
      render 'new'
      end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = current_user.posts.where(id: params[:id]).first

    if !@post.present?
      redirect_to root_path
    end
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to root_path
  end

  private
  def post_params
    params.require(:post).permit(:title, :body, :tag_list)
  end
end

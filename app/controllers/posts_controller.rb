class PostsController < ApplicationController

  def new 
    @post = Post.new(author_id: params[:author_id])
  end
  
  def index
    if params[:author_id]
      @posts = Author.find(params[:author_id]).posts
    else
      @posts = Post.all
    end
  end

  def show
    if params[:author_id]
      @post = Author.find(params[:author_id]).posts.find(params[:id])
    else
      @post = Post.find(params[:id])
    end
  end

  def new
    if params[:author_id] && !Author.exists?(params[:author_id])
      redirect_to authors_path, alert: "Author not found."
    else
      @post = Post.new(author_id: params[:author_id])
    end
  end

  def create
    @post = Post.new(post_params)
    @post.save
    redirect_to post_path(@post)
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to post_path(@post)
  end

  def edit
    if params[:author_id]
      # establish existence of author_id
      author = Author.find_by(id: params[:author_id])
        # if it's there, find valid author
      if author.nil?
        redirect_to authors_path, alert: "Author not found."
      else
        # if an author is found, find posts using id
        @post = author.posts.find_by(id: params[:id])
        # filter through author.posts collection to make sure post id is in the author's posts
        redirect_to author_posts_path(author), alert: "Post not found." if @post.nil?
      end
    else
      @post = Post.find(params[:id])
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :author_id)
  end
end

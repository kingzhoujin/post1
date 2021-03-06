class PostsController < ApplicationController
  before_action :authenticate_user!, :only => [:create, :destroy]

  def index
    @posts = Post.order("id DESC").all #新贴文放前面
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.save

  end

  def destroy
    @post = current_user.posts.find(params[:id]) #只能删除自己的贴文
    @post.destroy

    render :js => "alert('ok');"
  end

    def like
    @post = Post.find(params[:id])
    unless @post.find_like(current_user)  # 如果已经按讚过了，就略过不再新增
      Like.create( :user => current_user, :post => @post)
    end

    redirect_to posts_path
  end

  def unlike
    @post = Post.find(params[:id])
    like = @post.find_like(current_user)
    like.destroy

    redirect_to posts_path
  end

  def toggle_flog
    @post = Post.find(params[:id])

    if @post.flag_at
      @post.flag_at = nil
    else
      @post.flag_at = Time.now
    end

    @post.save!

    render :json => { :message => "ok", :flag_at => @post.flag_at, :id => @post.id }
  end

    def rate
    @post = Post.find(params[:id])

    existing_score = @post.find_score(current_user)
    if existing_score
      existing_score.update( :score => params[:score] )
    else
      @post.scores.create( :score => params[:score], :user => current_user )
    end

    render :json => { :average_score => @post.average_score }
  end

  protected

  def post_params
    params.require(:post).permit(:content)
  end

end

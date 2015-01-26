class BlogsController < ApplicationController
  def index
    show
    render action: 'show'
  end

  def show
    if params[:id]
      @blog = Blog.find(params[:id])
    else
      @blog = Blog.first
    end
    @blog_entries = BlogEntry.select(:datetime, :id, :text, :title).
        where('blog_id = ?', @blog.id).order('datetime DESC').
        paginate(per_page: 10, page: params[:page])
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.new(blog_params)
    if @blog.save
      flash[:notice] = 'Blog was successfully created.'
      redirect_to action: :list
    else
      render action: 'new'
    end
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def update
    @blog = Blog.find(params[:id])
    if @blog.update_attributes(blog_params)
      flash[:notice] = 'Blog was successfully updated.'
      redirect_to :action => 'show', :id => @blog
    else
      render :action => 'edit'
    end
  end

  def destroy
    Blog.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  private

  def blog_params
    params.require(:blog).permit(:title)
  end
end

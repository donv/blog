class BlogsController < ApplicationController
  def index
    list
    render :action => 'list', :id => Blog.find(:first)
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    if params[:id]
      @blog = Blog.find(params[:id])
    else
      @blog = Blog.find(:first)
    end
    @blog_entry_pages, @blog_entries = paginate :blog_entries, :per_page => 10, :conditions => "blog_id = #{@blog.id}", :order => 'datetime DESC'
  end

  def show
    @blog_entry = BlogEntry.find(params[:id])
    @blog = @blog_entry.blog
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.new(params[:blog])
    if @blog.save
      flash[:notice] = 'Blog was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def update
    @blog = Blog.find(params[:id])
    if @blog.update_attributes(params[:blog])
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
end

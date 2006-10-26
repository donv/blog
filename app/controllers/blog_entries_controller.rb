class BlogEntriesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @blog_entry_pages, @blog_entries = paginate :blog_entries, :per_page => 10
  end

  def show
    @blog_entry = BlogEntry.find(params[:id])
    @blog = @blog_entry.blog
  end

  def new
    @blog_entry = BlogEntry.new
    @blog_entry.blog_id = params[:blog_id]
    @blog = @blog_entry.blog
  end

  def create
    @blog_entry = BlogEntry.new(params[:blog_entry])
    if @blog_entry.save
      flash[:notice] = 'BlogEntry was successfully created.'
      redirect_to :action => 'show', :id => @blog_entry
    else
      render :action => 'new'
    end
  end

  def edit
    @blog_entry = BlogEntry.find(params[:id])
  end

  def update
    @blog_entry = BlogEntry.find(params[:id])
    if @blog_entry.update_attributes(params[:blog_entry])
      flash[:notice] = 'BlogEntry was successfully updated.'
      redirect_to :action => 'show', :id => @blog_entry
    else
      render :action => 'edit'
    end
  end

  def destroy
    BlogEntry.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

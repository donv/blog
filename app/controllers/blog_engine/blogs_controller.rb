# frozen_string_literal: true

module BlogEngine
  class BlogsController < ApplicationController
    def index
      if (@blog = Blog.first)
        show
        render action: 'show'
      else
        redirect_to action: :new
      end
    end

    def show
      @blog ||= Blog.find(params[:id])
      @blog_entries = BlogEntry.select(:datetime, :id, :text, :title)
                               .where('blog_id = ?', @blog.id).order('datetime DESC')
                               .paginate(per_page: 10, page: params[:page])
    end

    def new
      @blog = Blog.new
    end

    def create
      @blog = Blog.new(blog_params)
      if @blog.save
        flash[:notice] = 'Blog was successfully created.'
        redirect_to action: :index
      else
        render action: 'new'
      end
    end

    def edit
      @blog = Blog.find(params[:id])
    end

    def update
      @blog = Blog.find(params[:id])
      if @blog.update(blog_params)
        flash[:notice] = 'Blog was successfully updated.'
        redirect_to action: 'show', id: @blog
      else
        render action: 'edit'
      end
    end

    def destroy
      Blog.find(params[:id]).destroy
      redirect_to action: :index
    end

    private

    def blog_params
      params.require(:blog).permit(:title)
    end
  end
end

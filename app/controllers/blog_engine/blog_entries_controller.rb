# frozen_string_literal: true

module BlogEngine
  class BlogEntriesController < ApplicationController
    def index
      @blog_entries = BlogEntry.paginate(per_page: 10, page: params[:page])
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
      @blog_entry = BlogEntry.new(blog_entry_params)
      if @blog_entry.save
        flash[:notice] = 'BlogEntry was successfully created.'
        redirect_to action: :show, id: @blog_entry
      else
        render action: :new
      end
    end

    def edit
      @blog_entry = BlogEntry.find(params[:id])
      @blog = @blog_entry.blog
    end

    def update
      @blog_entry = BlogEntry.find(params[:id])
      if @blog_entry.update(blog_entry_params)
        flash[:notice] = 'BlogEntry was successfully updated.'
        redirect_to action: :show, id: @blog_entry
      else
        render action: :edit
      end
    end

    def destroy
      BlogEntry.find(params[:id]).destroy
      redirect_to action: :index
    end

    private

    def blog_entry_params
      params.require(:blog_entry).permit(:blog_id, :datetime, :text, :title)
    end
  end
end

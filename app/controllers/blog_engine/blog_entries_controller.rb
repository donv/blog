# frozen_string_literal: true

module BlogEngine
  class BlogEntriesController < ApplicationController
    skip_before_action :login_required, only: %i[index show]

    def index
      @blog_entries = BlogEntry.paginate(per_page: 10, page: params[:page])
    end

    def show
      @blog_entry = BlogEntry.find(params.expect(:id))
      @blog = @blog_entry.blog
    end

    def new
      @blog_entry = BlogEntry.new
      @blog_entry.blog_id = params[:blog_id]
      @blog = @blog_entry.blog
    end

    def edit
      @blog_entry = BlogEntry.find(params.expect(:id))
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

    def update
      @blog_entry = BlogEntry.find(params.expect(:id))
      if @blog_entry.update(blog_entry_params)
        flash[:notice] = 'BlogEntry was successfully updated.'
        redirect_to action: :show, id: @blog_entry
      else
        render action: :edit
      end
    end

    def destroy
      BlogEntry.find(params.expect(:id)).destroy
      redirect_to action: :index
    end

    private

    def blog_entry_params
      params.expect(blog_entry: [:blog_id, :datetime, :text, :title])
    end
  end
end

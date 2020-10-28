# frozen_string_literal: true

require 'mini_magick'

module BlogEngine
  class ImagesController < ApplicationController
    def index
      @images = Image.all
    end

    def show
      image = Image.find(params[:id])
      headers['Expires'] = 1.year.from_now.httpdate
      send_data(image.picture_data,
                # :filename     => image.title,
                filename: "Blog Image #{image.id}",
                type: image.picture_content_type,
                disposition: 'inline')
    end

    def thumbnail
      image = Image.find(params[:id])
      image_data = image.picture_data
      original_image = MiniMagick::Image.read(image_data)
      thumbnail_image = original_image.resize('160')
      headers['Expires'] = 1.year.from_now.httpdate
      send_data(thumbnail_image.to_blob,
                filename: "Blog Image #{image.id}",
                type: image.picture_content_type,
                disposition: 'inline')
    end

    def new
      @image = Image.new
      @image.blog_entry_id = params[:blog_entry_id]
      @blog = BlogEntry.find(params[:blog_entry_id]).blog
    end

    def create
      @image = Image.new(image_params)
      if @image.save
        flash[:notice] = 'Image was successfully created.'
        redirect_to controller: :blog_entries, action: :show, id: @image.blog_entry
      else
        render action: :new
      end
    end

    def edit
      @image = Image.find(params[:id])
    end

    def update
      @image = Image.find(params[:id])
      if @image.update(image_params)
        flash[:notice] = 'Image was successfully updated.'
        redirect_to action: :show, id: @image
      else
        render action: :edit
      end
    end

    def destroy
      Image.find(params[:id]).destroy
      redirect_to action: :index
    end

    private

    def image_params
      params.require(:image).permit(:blog_entry_id)
    end
  end
end

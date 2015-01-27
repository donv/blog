class ImagesController < ApplicationController
  def index
    @images = Image.paginate(per_page: 10, page: params[:page])
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
    original_image = Magick::Image.from_blob(image_data)[0]
    scale = 160.0 / original_image.columns
    thumbnail_image = original_image.thumbnail(scale)
    headers['Expires'] = 1.year.from_now.httpdate
    send_data(thumbnail_image.to_blob,
#              :filename     => image.title,
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
    if @image.update_attributes(image_params)
      flash[:notice] = 'Image was successfully updated.'
      redirect_to action: :show, id: @image
    else
      render action: :edit
    end
  end

  def destroy
    Image.find(params[:id]).destroy
    redirect_to :action => :index
  end

  private

  def image_params
    params.require(:image).permit(:blog_entry_id)
  end
end
